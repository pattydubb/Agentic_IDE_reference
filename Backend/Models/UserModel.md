# User Model

This document provides documentation for the User Model, which defines the structure and behavior of user data.

## Schema Definition

```javascript
const userSchema = new Schema({
  email: {
    type: String,
    required: true,
    unique: true,
    lowercase: true,
    trim: true,
    validate: {
      validator: (v) => /^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/.test(v),
      message: props => `${props.value} is not a valid email address!`
    }
  },
  password: {
    type: String,
    required: true,
    minlength: 8,
    select: false // Do not include in queries by default
  },
  name: {
    type: String,
    required: true,
    trim: true,
    minlength: 2,
    maxlength: 50
  },
  role: {
    type: String,
    enum: ['user', 'admin', 'moderator'],
    default: 'user'
  },
  profilePicture: {
    type: String,
    default: null
  },
  isActive: {
    type: Boolean,
    default: true
  },
  lastLogin: {
    type: Date,
    default: null
  },
  passwordResetToken: {
    type: String,
    default: null
  },
  passwordResetExpires: {
    type: Date,
    default: null
  }
}, {
  timestamps: true // Automatically add createdAt and updatedAt fields
});
```

## Indexes

```javascript
// For efficient email lookups during login
userSchema.index({ email: 1 });

// For filtering users by role and activity status
userSchema.index({ role: 1, isActive: 1 });
```

## Methods

### Instance Methods

```javascript
// Compare provided password with stored hash
userSchema.methods.comparePassword = async function(candidatePassword) {
  return await bcrypt.compare(candidatePassword, this.password);
};

// Generate password reset token
userSchema.methods.generatePasswordResetToken = function() {
  const resetToken = crypto.randomBytes(32).toString('hex');
  
  this.passwordResetToken = crypto
    .createHash('sha256')
    .update(resetToken)
    .digest('hex');
    
  this.passwordResetExpires = Date.now() + 10 * 60 * 1000; // 10 minutes
  
  return resetToken;
};
```

### Static Methods

```javascript
// Find user by email (used during login)
userSchema.statics.findByEmail = function(email) {
  return this.findOne({ email }).select('+password');
};

// Find all active admins
userSchema.statics.findActiveAdmins = function() {
  return this.find({ role: 'admin', isActive: true });
};
```

## Middleware Hooks

```javascript
// Hash password before saving
userSchema.pre('save', async function(next) {
  // Only hash the password if it has been modified (or is new)
  if (!this.isModified('password')) return next();
  
  try {
    const salt = await bcrypt.genSalt(10);
    this.password = await bcrypt.hash(this.password, salt);
    next();
  } catch (error) {
    next(error);
  }
});

// Update lastLogin timestamp after successful login
userSchema.post('findOneAndUpdate', function(doc) {
  if (doc && this._update.lastLogin) {
    console.log(`User ${doc.email} logged in at ${doc.lastLogin}`);
  }
});
```

## Virtuals

```javascript
// Full name virtual getter
userSchema.virtual('fullName').get(function() {
  return `${this.firstName} ${this.lastName}`;
});

// Is admin virtual getter
userSchema.virtual('isAdmin').get(function() {
  return this.role === 'admin';
});
```

## Data Transformation

```javascript
// Transform the output by removing sensitive fields
userSchema.set('toJSON', {
  transform: (doc, ret) => {
    delete ret.password;
    delete ret.passwordResetToken;
    delete ret.passwordResetExpires;
    return ret;
  }
});
```

## Relationships

The User model has the following relationships with other models:

- One-to-Many with Posts (a user can create multiple posts)
- One-to-Many with Comments (a user can create multiple comments)
- Many-to-Many with Groups (a user can belong to multiple groups)

These relationships are typically defined in the respective related models rather than within the User model itself. 