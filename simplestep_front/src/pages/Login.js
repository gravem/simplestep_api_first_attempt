import { useState } from 'react'; // google react hooks later
import InputField from '../components/InputField';
import PrimaryButton from '../components/PrimaryButton';

export const Login = () => {
  const handleFormSubmit = (event) => {
    event.preventDefault();
    const email = event.target.email.value;
    const password = event.target.password.value;
    const loginUrl = 'http://localhost:3001/login'; // Adjust the URL/port as necessary

    // Prepare the request option
    const requestOptions = {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        user: {
          email: email,
          password: password,
        },
      }),
    };

    // Call the backend with values
    fetch(loginUrl, requestOptions)
      .then((response) => response.json())
      .then((data) => {
        if (data.status && data.status.code === 200) {
          // Assuming the response contains a JWT token named 'JWT'
          console.log('Login successful', data);
          // Implement actions post-login success, such as redirecting the user or setting global user state
          localStorage.setItem('token', data.jwt);
          window.location.href = '/';
          // Redirect or update UI accordingly
        } else {
          console.log('Login failed', data);
          // Handle login failure (e.g., show an error message)
        }
      })
      .catch((error) => {
        console.error('There was an error!', error);
      });
  };

  const [buttonText, setButtonText] = useState(
    'Click me. I useState, so I change!'
  );
  return (
    <div className='App'>
      <h1 className=''>Welcome to SimpleStep</h1>
      <h3>For when you need repeatable checklists, not a todo list</h3>
      <form
        onSubmit={handleFormSubmit}
        className='Login-form shadow'
      >
        <InputField
          label='Email'
          type='text'
          id='email'
          name='email'
          autocomplete='email'
          placeholder='email'
        />
        <InputField
          label='Password'
          type='password'
          id='password'
          name='password'
          autocomplete='current-password'
          placeholder='password'
        />
        <PrimaryButton buttonText='Come on in' />
      </form>
      <button
        className='btn'
        onClick={() => setButtonText('Yey! I used setButtonText')}
      >
        {buttonText}
      </button>
    </div>
  );
};
