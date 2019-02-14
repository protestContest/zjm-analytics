document.addEventListener('DOMContentLoaded', () => {
  let selectTargets = document.querySelectorAll('[data-js-selects]');
  selectTargets.forEach(selectTarget => {

    selectTarget.addEventListener('click', (e) => {
      let params = e.target.dataset.jsSelects.split(',');
      let allEls = document.querySelectorAll(params[0]);
      let targetElSelector = params[1];
      let targetEl = (targetElSelector === '&') ? selectTarget : document.querySelector(targetElSelector);
      let activeClass = params[2];

      allEls.forEach(el => {
        el.classList.remove(activeClass);
      });
      targetEl.classList.add(activeClass);
    });
  });
});
