/* Copies the contents of an element to the clipboard.
 *
 * Accepts two comma-separated parameters:
 *  - Selector for element to copy
 *  - String to replace activator's text with
 *
 * `data-js-toggle='#code,Copied!'`
 */
document.addEventListener('turbolinks:load', () => {
  let activators = document.querySelectorAll('[data-js-copy]');
  activators.forEach(activator => {

    activator.addEventListener('click', (event) => {
      let params = activator.dataset.jsCopy.split(',');
      let targetSelector = params[0];
      let resultText = (params.length > 1) ? params[1] : activator.innerText;

      let target = document.querySelector(targetSelector);
      copyCode(target, event.target);

      event.stopPropagation();
    });

  });
});


function copyCode(el, button) {
  var succeed = true;

  var target = document.createElement("textarea");
  target.style.position = "fixed";
  target.style.left = "0px";
  target.style.top = "0px";
  target.style.pointerEvents = "none";
  target.style.opacity = "0";
  document.body.appendChild(target);
  target.textContent = el.textContent;

  var currentFocus = document.activeElement;
  target.focus();
  target.setSelectionRange(0, target.value.length);
  try {
    document.execCommand("copy");
  } catch(e) {
    succeed = false;
  }

  if (currentFocus && typeof currentFocus.focus === "function") {
      // currentFocus.focus();
  }
  target.textContent = "";

  if (succeed) {
    button.textContent = "Copied!";
    button.disabled = true;
  }
}
