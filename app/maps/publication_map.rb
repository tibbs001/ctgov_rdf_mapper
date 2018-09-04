module PublicationMap
  include RdfPrefixes
  extend self

  def uri(namespace,pub)
    "#{namespace}pub#{pub.uid}"
  end

  def types(pub)
    if self.bibo_pub_classes.include? pub.pub_type
      [bibo(pub.pub_type)]
    else
      if self.vivo_pub_classes.include? pub.pub_type
        [core(pub.pub_type)]
      else
        if self.foaf_pub_classes.include? pub.pub_type
          [foaf(pub.pub_type)]
        end
      end
    end
  end

  def inferred_types(pub)
    inferred_type_array = [owl("Thing"), bibo("Document")]
    case pub.pub_type
    when 'Academic Article','Blog Posting','Conference Paper','Review','Editorial Article'
      inferred_type_array << bibo('Article')
    when 'Film', 'Video'
      inferred_type_array << bibo('Audio-Visual Document')
    when 'Proceedings'
      inferred_type_array << bibo('Book')
    when 'Legislation', 'Legal Case Document'
      inferred_type_array << bibo('Legal Document')
    when 'Information Resource', 'Map', 'Image'
      inferred_type_array << bibo('Image')
    when 'Software', 'Dataset', 'Collection'
      inferred_type_array << bibo('Information Resource')
      inferred_type_array << bibo('Image')
    end
    return inferred_type_array
  end

  def child_maps(pub)
    [pub.authorship, pub.journal]
  end
 
  def properties(pub)
    { 
        rdfs("label")                           => pub.title,
#        dcterms("title")                        => pub.title,
        bibo("pmid")                            => pub.pmid,
        core("informationResourceInAuthorship") => pub.authorship,
#       vivo("webpage")                         => VivoMapper::WebPage.new(:uid => pub.webpage),
        duke("authorList")                      => pub.author_list,
        core("hasPublicationVenue")             => (pub.journal if pub.journal),
        core("dateTimeValue")                   => (pub.pub_date_object if pub.pub_date_object),
        bibo("volume")                          => (pub.volume if pub.volume),
        bibo("issue")                           => (pub.issue if pub.issue),
        bibo("edition")                         => (pub.edition if pub.edition),
        bibo("number")                          => (pub.number if pub.number),
        bibo("section")                         => (pub.section if pub.section),
        bibo("oclcNumber")                      => (pub.oclc_number if pub.oclc_number),
        bibo("pageStart")                       => (pub.start_page if pub.start_page),
        bibo("pageEnd")                         => (pub.end_page if pub.end_page),
        bibo("abstract")                        => (pub.abstract if pub.abstract)
    }
  end

  def self.bibo_pub_classes
     [
      'Academic Article',
      'Article',
      'Audio Document',
      'Audio-Visual Document',
      'Book',
      'Collected Document',
      'Collection',
      'Document',
      'Document Part',
      'Film',
      'Image',
      'Legal Document',
      'Legislation',
      'Legal Case Document',
      'Manual',
      'Manuscript',
      'Map',
      'Note',
      'Patent',
      'Proceedings',
      'Reference Source',
      'Report',
      'Slideshow',
      'Standard',
      'Thesis',
      'Video',
      'Webpage'
     ]
  end

  def self.vivo_pub_classes
    [
     'Blog Posting',
     'Case Study',
     'Catalog',
     'Conference Paper',
     'Conference Poster',
     'Dataset',
     'Information Resource',
     'News Release',
     'Research Proposal',
     'Review',
     'Score',
     'Screenplay',
     'Software',
     'Speech',
     'Translation',
     'Working Paper',
     'Editorial Article'
    ]
  end

  def self.foaf_pub_classes
    [ 'Image' ]
  end
end
