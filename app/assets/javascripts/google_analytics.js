document.addEventListener('turbolinks:load', function(event) {
  debugger
  if (typeof gtag === 'function') {
    gtag('config', 'UA-155160951-1', {
      'page_location': event.data.url
    })
  }
})