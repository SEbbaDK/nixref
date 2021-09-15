class SearchResult
  include JSON::Serializable

  property resource_name : String
  property url : String
  property title : String
  property blurb : String

  def initialize(resource_name : String, url : String, title : String, blurb : String)
    @resource_name = resource_name
    @url = url
    @title = title
    @blurb = blurb
  end
end

# A resource is a collection of documentation
abstract class Resource
  # Must be unique, is used for URLs
  abstract def name
  # Get the resource. Currently, a string which is HTML, should be some object representing a document
  abstract def getResource(url : String)
  # Search in this resource
  abstract def search(text : String)
end
