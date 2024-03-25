import { Routes, Route } from 'react-router'; //

import { Home } from './pages/Home';
import './App.css';
import { Login } from './pages/Login';

// YOur app goes inside here
function App() {
  return (
    <Routes>
      <Route
        path='/'
        element={<Home />}
      />
      <Route
        path='/login'
        element={<Login />}
      />
    </Routes>
  );
}

export default App;
