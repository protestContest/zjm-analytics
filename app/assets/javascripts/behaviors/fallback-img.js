/* Replaces an image src when the original image doesn't load.
 *
 * Accepts one parameter:
 *  - URL for fallback image
 *
 * `data-js-fallback-img='/fallback.png'`
 */
document.addEventListener('turbolinks:load', () => {
  let activators = document.querySelectorAll('[data-js-fallback-img]');
  activators.forEach(activator => {

    let fallback = activator.dataset.jsFallbackImg;
    if (activator.getAttribute('src').length === 0) {
      activator.src = fallback;
      activator.classList.add('_fallback');
    }

    activator.addEventListener('error', (event) => {
      activator.src = fallback;
      activator.classList.add('_fallback');
      event.stopPropagation();
    });

  });
});
