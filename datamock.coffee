firstNames = [
  "James"
  "John"
  "Robert"
  "Michael"
  "William"
  "David"
  "Richard"
  "Charles"
  "Joseph"
  "Thomas"
  "Mary"
  "Patricia"
  "Linda"
  "Barbara"
  "Elizabeth"
  "Jennifer"
  "Maria"
  "Susan"
  "Margaret"
  "Dorothy"
]
lastNames = [
  "Smith"
  "Johnson"
  "Williams"
  "Jones"
  "Brown"
  "Davis"
  "Miller"
  "Wilson"
  "Moore"
  "Taylor"
  "Anderson"
  "Thomas"
  "Jackson"
  "White"
  "Harris"
  "Martin"
  "Thompson"
  "Garcia"
  "Martinez"
  "Robinson"
]
emailNames = (n.toLowerCase() for n in firstNames)
emailDomains = (n.toLowerCase() for n in lastNames)
emailTLD = ["org", "com", "net"]
lorem = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed vel velit et massa
ultricies viverra et eget nunc. Donec laoreet hendrerit sapien, eget rutrum
lectus posuere vitae. Proin lobortis rhoncus enim, nec faucibus augue pharetra
vel. Donec at nisi ligula, at gravida dui. Nulla sed sapien turpis, quis ornare
nibh. Duis lacinia, leo non vehicula dapibus, nulla orci eleifend ligula, a
molestie sapien odio et nisi. Pellentesque vel ligula sem. Maecenas auctor
consectetur convallis.
"""

randChoice = (arr) ->
  arr[Math.floor(Math.random() * arr.length)]

genName = ->
  "#{randChoice(firstNames)} #{randChoice(lastNames)}"

genEmail = ->
  "#{randChoice(emailNames)}@#{randChoice(emailDomains)}.#{randChoice(emailTLD)}"

attribSel = ($sel, attr) ->
  attr = "[#{attr}]"
  if $sel.is(attr)
    $sel.add($sel.find(attr))
  else
    $sel = $sel.find(attr)
  $sel

$.fn.datamock = ->

  $(@).each ->

    # We reverse results to traverse from inner clones moving up
    $(attribSel($(@), 'data-mock-clone').get().reverse()).each ->
      $el = $(@)
      clone = parseInt($el.data('mock-clone'), 10)
      $parent = $el.parent()
      $last = $el.siblings('[data-mock-id]').last()
      if $last.size() == 1
        if $el.data('mock-clone-fixed')
          return
        start = parseInt($last.data('mock-id'), 10)
        init = false
      else
        start = 1
        init = true
      $el.attr('data-mock-id', start)
      start++
      for i in [start...start + clone - (init ? 1 : 0)]
        $parent.append($el
          .clone()
          .attr('data-mock-id', i)
          .removeAttr('data-mock-clone'))

    attribSel($(@), 'data-mock').each ->
      $el = $(@)
      switch $el.data('mock')
        when 'id'
          text = $el.closest('[data-mock-id]').data('mock-id')
        when 'name'
          text = genName()
        when 'email'
          text = genEmail()
        when 'lorem'
          text = lorem
      $el.text(text)

    attribSel($(@), 'data-mock-choices').each ->
      $el = $(@)
      $el.text(randChoice($el.data('mock-choices').split(',')))

    attribSel($(@), 'data-mock-choice').show().each ->
      $el = $(@)
      unless $el.is(':visible')
        return
      choiceSel = "[data-mock-choice='#{$el.data('mock-choice')}']:visible"
      $siblings = $el.siblings(choiceSel)
      unless $siblings.size() > 0
        return
      $choices = $el.add($siblings)
      $choice = $(randChoice($choices.get()))
      $choice.siblings(choiceSel).hide()
