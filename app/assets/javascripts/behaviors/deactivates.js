/* Removes the active class for all elements when clicked. Useful when used on
 * the body tag or other container.
 *
 * `data-js-deactivates`
 */
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
