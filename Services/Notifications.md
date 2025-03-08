# Notifications Service

This document provides documentation for the notifications service, which handles various types of user notifications across different channels.

## Service Overview

The notifications service is responsible for:
- Sending email notifications
- Generating in-app notifications
- Sending SMS messages
- Managing push notifications for mobile devices
- Handling notification preferences
- Tracking notification delivery and engagement

## Implementation Details

### Notification Providers

This application uses the following providers for different notification channels:
- **Email**: [Provider Name, e.g., SendGrid, Mailgun, Amazon SES]
- **SMS**: [Provider Name, e.g., Twilio, Nexmo]
- **Push Notifications**: [Provider Name, e.g., Firebase Cloud Messaging, Apple Push Notification Service]
- **In-App**: Custom implementation using WebSockets/Server-Sent Events

### Configuration

```javascript
// Configuration settings for notification service
const notificationConfig = {
  email: {
    apiKey: process.env.EMAIL_API_KEY,
    sender: process.env.EMAIL_SENDER,
    templates: {
      welcome: 'template_id_1',
      passwordReset: 'template_id_2',
      orderConfirmation: 'template_id_3'
    }
  },
  sms: {
    accountSid: process.env.SMS_ACCOUNT_SID,
    authToken: process.env.SMS_AUTH_TOKEN,
    phoneNumber: process.env.SMS_PHONE_NUMBER
  },
  push: {
    projectId: process.env.PUSH_PROJECT_ID,
    privateKey: process.env.PUSH_PRIVATE_KEY
  },
  defaultPreferences: {
    email: true,
    sms: false,
    push: true,
    inApp: true
  }
};
```

## Notification Types

| Type | Description | Channels | Template |
|------|-------------|----------|----------|
| `welcome` | New user registration | Email | Welcome email with getting started guide |
| `account_verification` | Email verification | Email | Verification link |
| `password_reset` | Password reset request | Email | Reset link |
| `order_confirmation` | Order placed | Email, SMS, In-App | Order details |
| `order_shipped` | Order shipped | Email, SMS, Push, In-App | Tracking information |
| `order_delivered` | Order delivered | Email, Push, In-App | Delivery confirmation |
| `payment_success` | Payment processed | Email, In-App | Receipt |
| `payment_failed` | Payment failed | Email, SMS, In-App | Payment retry instructions |
| `subscription_renewal` | Upcoming subscription renewal | Email | Renewal notice |
| `subscription_expired` | Subscription ended | Email, In-App | Renewal options |
| `product_update` | New features or updates | Email, Push, In-App | Update details |
| `security_alert` | Suspicious activity | Email, SMS | Security information |

## Email Templates

The notification service uses pre-designed templates for consistent branding and content structure:

### Welcome Email Template

```
Subject: Welcome to [Application Name]!

Hi {{user.name}},

Thank you for joining [Application Name]! We're excited to have you on board.

Here are a few things you can do to get started:
- Complete your profile
- Explore our features
- Check out our documentation

If you have any questions, please reply to this email or contact our support team.

Best regards,
The [Application Name] Team
```

### Order Confirmation Template

```
Subject: Your Order #{{order.id}} Confirmation

Hi {{user.name}},

Thank you for your order! We've received your purchase and are processing it now.

Order Details:
- Order #: {{order.id}}
- Date: {{order.date}}
- Total: {{order.total}}

Items:
{{#each order.items}}
- {{this.quantity}}x {{this.name}} - {{this.price}}
{{/each}}

Shipping Address:
{{order.shippingAddress}}

You'll receive another notification when your order ships.

Thank you for shopping with us!

The [Application Name] Team
```

## Notification Workflows

### Order Lifecycle Notifications

1. **Order Placed**
   - Send order confirmation email
   - Create in-app notification
   - Send SMS if enabled

2. **Order Processing**
   - Update in-app notification status

3. **Order Shipped**
   - Send shipping confirmation email with tracking information
   - Update in-app notification
   - Send push notification to mobile device
   - Send SMS with tracking link if enabled

4. **Order Delivered**
   - Send delivery confirmation email
   - Update in-app notification
   - Send push notification

## Integration with Frontend

### In-App Notification Component

```javascript
// React component for in-app notifications
const NotificationCenter = () => {
  const [notifications, setNotifications] = useState([]);
  const [unreadCount, setUnreadCount] = useState(0);
  
  useEffect(() => {
    // Connect to WebSocket for real-time notifications
    const socket = io('/notifications');
    
    socket.on('notification', (notification) => {
      setNotifications(prev => [notification, ...prev]);
      setUnreadCount(prev => prev + 1);
    });
    
    // Fetch existing notifications
    const fetchNotifications = async () => {
      try {
        const response = await api.get('/notifications');
        setNotifications(response.data.notifications);
        setUnreadCount(response.data.unreadCount);
      } catch (error) {
        console.error('Failed to fetch notifications:', error);
      }
    };
    
    fetchNotifications();
    
    return () => socket.disconnect();
  }, []);
  
  const markAsRead = async (notificationId) => {
    try {
      await api.post(`/notifications/${notificationId}/read`);
      
      setNotifications(prev => 
        prev.map(notification => 
          notification.id === notificationId 
            ? { ...notification, read: true } 
            : notification
        )
      );
      
      setUnreadCount(prev => Math.max(0, prev - 1));
    } catch (error) {
      console.error('Failed to mark notification as read:', error);
    }
  };
  
  return (
    <div className="notification-center">
      <div className="notification-header">
        <h3>Notifications</h3>
        <span className="unread-badge">{unreadCount}</span>
      </div>
      <div className="notification-list">
        {notifications.length === 0 && (
          <p className="no-notifications">No notifications yet</p>
        )}
        {notifications.map(notification => (
          <div 
            key={notification.id} 
            className={`notification-item ${notification.read ? 'read' : 'unread'}`}
            onClick={() => markAsRead(notification.id)}
          >
            <div className="notification-icon">
              {getIconForType(notification.type)}
            </div>
            <div className="notification-content">
              <p className="notification-message">{notification.message}</p>
              <p className="notification-time">{formatTime(notification.createdAt)}</p>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};
```

## User Preferences

Users can customize their notification preferences through the application settings:

```javascript
// Example user notification preferences
{
  "email": {
    "marketing": false,
    "orderUpdates": true,
    "productUpdates": true,
    "security": true
  },
  "sms": {
    "orderUpdates": true,
    "security": true
  },
  "push": {
    "orderUpdates": true,
    "chat": true,
    "productUpdates": false
  },
  "inApp": {
    "all": true
  }
}
```

## Testing

The notification service provides a sandbox environment for testing:
- Test email delivery without sending actual emails
- Preview email templates with test data
- Simulate push notifications in development environments 