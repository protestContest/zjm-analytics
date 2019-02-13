// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require turbolinks
//= require_tree .

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
