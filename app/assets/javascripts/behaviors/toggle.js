/* Toggles an element's active class when an element is clicked. Active class
 * is `_active`.
 *
 * Accepts any number of comma-separated parameters:
 *  - Selector for element to toggle the active class
 *  - Special "&" refers to the activating element
 *
 * `data-js-toggle='&,.boxDetail,#menu'`
 */
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
