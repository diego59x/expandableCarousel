sub init()
    m.focusImage = m.top.findNode("focusImage")
    m.imageMovie = m.top.findNode("imageMovie")
    m.theLabel = m.top.findNode("theLabel")
    m.items = m.top.findNode("items")
end sub

sub itemContentChanged()
    m.theLabel.text = m.top.itemContent.title
    m.imageMovie.uri = m.top.itemContent.poster
end sub

sub currRectChanged()
    if (m.top.currRect.width > 231)
        m.imageMovie.uri = m.top.itemContent.providerLogo
    else
        m.imageMovie.uri = m.top.itemContent.poster
    end if

    m.focusImage.width = m.top.currRect.width
    m.focusImage.height = m.top.currRect.height


    m.imageMovie.width = m.top.currRect.width
    m.imageMovie.height = m.top.currRect.height
end sub


sub focusPercentChanged()

    if ( m.top.focusPercent > 0.5)
        m.focusImage.visible = true
    else if (m.top.focusPercent < 0.5)
        m.focusImage.visible = false
    end if

end sub