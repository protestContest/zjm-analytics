document.addEventListener('DOMContentLoaded', () => {
  let activators = document.querySelectorAll('[data-js-toggle]');
  activators.forEach(activator => {

    activator.addEventListener('click', (event) => {
      let targetSelectors = activator.dataset.jsToggle.split(',');
      targetSelectors.forEach(targetSelector => {
        let targetEl = (targetSelector === '&') ? activator : document.querySelector(targetSelector);
        if (targetEl) {
          targetEl.classList.toggle('_active');
        }
      });

      event.stopPropagation();
    });

  });
});
