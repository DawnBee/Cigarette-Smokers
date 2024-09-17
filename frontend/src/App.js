import './App.css';
import { useState } from 'react';
import { startSimulation } from './api';

function App() {
  const [message, setMessage] = useState('');

  const handleStartSimulation = async () => {
    try {
      const data = await startSimulation();
      setMessage(data.message);
    } catch (error) {
      setMessage('Failed to start simulation');
    }
  };

  return (
    <div className="App">
      <h1>Cigarette Smokers!</h1>
      <button onClick={handleStartSimulation}>Start Simulation</button>
      <p>{message}</p>
    </div>
  );
}

export default App;