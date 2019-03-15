/* Toggles an element's active class when an element is clicked. Active class
 * is `_active`.
 *
 * Accepts any number of comma-separated parameters:
 *  - Selector for element to toggle the active class
 *  - Special "&" refers to the activating element
 *
 * `data-js-toggle='&,.boxDetail,#menu'`
 */
document.addEventListener('turbolinks:load', () => {
  let activators = document.querySelectorAll('[data-js-toggle]');
  activators.forEach(activator => {

    activator.addEventListener('click', (event) => {
      activator.classList.add('__toggle-self');
      let targetSelectors = activator.dataset.jsToggle.split(',');
      targetSelectors.forEach(targetSelector => {
        targetSelector = targetSelector.replace('&', '.__toggle-self');
        let targetEl = document.querySelector(targetSelector);
        if (targetEl) {
          targetEl.classList.toggle('_active');
        }
      });
      activator.classList.remove('__toggle-self');

      event.stopPropagation();
    });

  });
});
