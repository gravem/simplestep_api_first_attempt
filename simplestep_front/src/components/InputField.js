const InputField = ({ label, type, id, autocomplete, placeholder }) => {
  return (
    <div className='form-field'>
      <label htmlFor='{id}'>{label}</label>
      <input
        type={type}
        id={id}
        autoComplete={autocomplete}
        placeholder={placeholder}
      ></input>
    </div>
  );
};

export default InputField;
