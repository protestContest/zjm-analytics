/* Selects one element from many, giving it an active class and deactivating
 * others. The active class is `_active`.
 *
 * Accepts 2 comma-separated parameters:
 *  - Selector for all elements in category
 *  - Selector for element to become active
 *
 * `data-js-selects='.categoryElements,#elementToActivate'
 */
document.addEventListener('turbolinks:load', () => {
  let activators = document.querySelectorAll('[data-js-selects]');
  activators.forEach(activator => {

    activator.addEventListener('click', (event) => {
      let params = activator.dataset.jsSelects.split(',');
      let allEls = document.querySelectorAll(params[0]);
      let targetElSelector = params[1];
      let targetEl = (targetElSelector === '&') ? activator : document.querySelector(targetElSelector);
      let activeClass = '_active';

      allEls.forEach(el => {
        el.classList.remove(activeClass);
      });
      targetEl.classList.add(activeClass);

      event.stopPropagation();
    });
  });
});
