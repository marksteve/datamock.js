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

mockValues = ->
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
  switch
    when $el.is('input[type=textbox]')
      $el.val(text)
    else
      $el.text(text)
  $el.removeAttr('data-mock')

mockChoices = ->
  $el = $(@)
  $el.text(randChoice($el.data('mock-choices').split(',')))
  $el.removeAttr('data-mock-choices')

mockChoice = ->
  $el = $(@)
  choiceSel = "[data-mock-choice='#{$el.data('mock-choice')}']"
  $siblings = $el.siblings(choiceSel)
  if $siblings.size() > 0
    $choices = $el.add($siblings)
    $choice = $(randChoice($choices.get()))
    $choice.siblings(choiceSel).remove()
    $choice.removeAttr('data-mock-choice')

mock = ($el) ->
  attribSel($el, 'data-mock').each(mockValues)
  attribSel($el, 'data-mock-choices').each(mockChoices)
  attribSel($el, 'data-mock-choice').show().each(mockChoice)

cache = {}

$.fn.datamock = ->

  $(@).each ->

    $this = $(@)

    unless cache[$this]
      cache[$this] = []
      # We reverse results to traverse from inner clones moving up
      $(attribSel($this, 'data-mock-clone').get().reverse()).each ->
        $el = $(@)
        $parent = $el.parent()
        cache[$this].push([$parent, $el.remove()])

    # Mock container
    mock($this)

    # Mock clones
    for $pair in cache[$this]
      $parent = $pair[0]
      $template = $pair[1]
      clone = parseInt($template.data('mock-clone'), 10)
      cloneCount = $template.data('mock-clone-count') or 0
      if cloneCount >= clone and $template.data('mock-clone-fixed')
        continue
      for i in [1..clone]
        $clone = $template
          .clone()
          .removeAttr('data-mock-clone')
          .attr('data-mock-id', cloneCount + i)
        $parent.append($clone) # Append first!
        mock($clone)
      cloneCount += clone
      $template.data('mock-clone-count', cloneCount)
