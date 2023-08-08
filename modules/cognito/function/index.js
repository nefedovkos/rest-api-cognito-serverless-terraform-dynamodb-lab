exports.handler = async (event) => {
    try {
      // Extract user details from the Cognito event
      const { request } = event;
      const { userAttributes } = request;
      const { username, email, userStatus } = userAttributes;
  
      // Your custom logic for the pre-sign-up trigger
      // For example, you can validate user data or add custom attributes to the userAttributes object
  
      return event; // Return the updated event object
    } catch (error) {
      console.error('Error handling pre-sign-up event:', error);
      throw new Error('Error handling pre-sign-up event');
    }
  };
  