import './App.css';
import { useState } from 'react';
import { startSimulation } from './api';

// Asset Import
import cigarImage from './assets/cigar.png';

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
    <>
      <img className="cigar" src={cigarImage} alt="cigar-image"/>
      <div className="container">
        <h1>Cigarette Smokers!</h1>
        <button className="start-btn" onClick={handleStartSimulation}>Start Simulation</button>
        <p className="msg">{message}</p>
      </div>
    </>

  );
}

export default App;