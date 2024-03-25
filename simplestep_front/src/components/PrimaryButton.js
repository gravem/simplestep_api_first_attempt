const PrimaryButton = ({ onClick, buttonText }) => {
  return (
    <button
      onClick={onClick}
      className='btn-pri'
    >
      {buttonText}
    </button>
  );
};

export default PrimaryButton;
