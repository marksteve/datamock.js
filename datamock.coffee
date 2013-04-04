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
      $el.text(text)

    attribSel($(@), 'data-mock-choices').each ->
      $el = $(@)
      $el.text(randChoice($el.data('mock-choices').split(',')))

    attribSel($(@), 'data-mock-choice').each ->
      $el = $(@)
      choiceSel = "[data-mock-choice='#{$el.data('mock-choice')}']"
      $sel = $el.add($el.siblings(choiceSel))
      $el = $sel.eq(Math.floor(Math.random() * $sel.size()))
      $el.siblings(choiceSel).remove()
