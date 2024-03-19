import { useState } from 'react'; // google hooks later

export const Login = () => {
  const handleFormSubmit = (event) => {
    event.preventDefault();
    const email = event.target.email.value;
    const password = event.target.password.value;
    console.log(event.target.email.value);
    console.log(event.target.password.value);
    console.log('Form submitter');
    // Call the backend with values
    // Check the response
    // if ok, redirect to logged in page
  };

  const [buttonText, setButtonText] = useState('Click me');
  // Make input, button into reusable component
  return (
    <div>
      <h1>Login page</h1>
      <form onSubmit={handleFormSubmit}>
        <label htmlFor='email'>Email</label>
        <input
          type='text'
          id='email'
          name='email'
        />
        <label htmlFor='password'>password</label>
        <input
          type='password'
          id='password'
          name='password'
        />
        <button>Come on in</button>
      </form>
      <button onClick={() => setButtonText('Yey!')}>{buttonText}</button>
    </div>
  );
};
