angular.module("laere.courses").directive "laereEmbed", ->
  restrict: 'E'
  link: ($scope, element) ->
    templates =
      youtube: (id) -> "<iframe width='420' height='315' src='//www.youtube.com/embed/#{id}' frameborder='0' allowfullscreen></iframe>"
    $scope.$watch 'data.content.url', (url, oldUrl) ->
      return element.html("") if not url?
      return if url is oldUrl
      embedTypeMap =
        'youtube': /.*(?:youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=)([^#\&\?]*).*/
        'vimeo': /vimeo\.com/gi
        'slides': /slid\.es/gi
        'speakerdeck': /speakerdeck\.com/gi
        'forms': /docs\.google\.com\/forms/gi
        'codepen': /codepen\.io/gi
        'image': /\.png|\.gif|\.jpg|\.jpeg/gi
        'text': /\.pdf|\.doc|\.docx|\.txt/gi

      for k, v of embedTypeMap
        match = url.match v
        if match and match[1]
          element.html(templates[k](match[1]))
          return

      element.html("")