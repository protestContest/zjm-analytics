document.addEventListener('turbolinks:load', () => {
  let activators = document.querySelectorAll('[data-enabletext]');
  activators.forEach(activator => {
    let targetSelector = activator.dataset.enabletext;
    let target = document.querySelector(targetSelector);
    let validationText = target.getAttribute('placeholder');
    target.addEventListener('input', (event) => {
      console.log(event.target.value);
      if (event.target.value === validationText) {
        activator.disabled = false;
      } else {
        activator.disabled = true;
      }
    });
  });
});
