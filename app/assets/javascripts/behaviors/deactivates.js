document.addEventListener('DOMContentLoaded', () => {
  let activators = document.querySelectorAll('[data-js-deactivates]');
  activators.forEach(activator => {

    activator.addEventListener('click', (event) => {
      let activeEls = document.querySelectorAll('._active');
      activeEls.forEach(el => {
        el.classList.remove('_active');
      });
    });

  });
});
