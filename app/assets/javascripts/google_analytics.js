document.addEventListener('turbolinks:load', function(event) {
  if (typeof gtag === 'function') {
    gtag('config', 'UA-155160951-1', {
      'page_location': event.data.url
    })
    gtag('config', 'AW-966099108', {
      'page_location': event.data.url
    })
  }
})