/* Sets a target element's text on hover
 *
 * Accepts two colon-separated parameters:
 *  - Selector for element to set text
 *  - Text of tooltip
 *
 * `data-js-tooltip='#tooltipDiv,Tooltip text'`
 */
document.addEventListener('turbolinks:load', () => {
  let activators = document.querySelectorAll('[data-js-tooltip]');
  activators.forEach(activator => {

    activator.addEventListener('mouseover', (event) => {
      let params = activator.dataset.jsTooltip.split(':');
      let targetSelector = params[0];
      let tooltipText = params[1];
      let target = document.querySelector(targetSelector);
      target.innerText = tooltipText;
    });

    activator.addEventListener('mouseleave', (event) => {
      let params = activator.dataset.jsTooltip.split(':');
      let targetSelector = params[0];
      let target = document.querySelector(targetSelector);
      target.innerText = '';
    });

  });
});
