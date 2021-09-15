require "./resource.cr"

class ExampleResource < Resource
  def name
    "example"
  end
  def getResource(url : String)
    "<b>hmm. this should be an object</b>"
  end
  def search(text : String)
    [SearchResult.new(name(), "result", "Example SearchResult", "This is the example result. Zoop Boing doop")]
  end
end
