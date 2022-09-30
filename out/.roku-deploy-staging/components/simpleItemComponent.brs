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

sub currTargetChanged()
    ' No estoy seguro de que podemos hacer con esta funcion
    ' currTarget va aumentando su valor hasta la nueva posicion
    ' if m.top.index = 0
    '     ' print "currTarget for item "; m.top.index; " changed to "; m.top.currTarget
    ' end if
end sub

sub currRectChanged()
    ' Esta es la funcion donde los tamaños cambian

    ' Cambiar la imagen a una mas amplia solo si es el item que se agranda 
    if (m.top.currRect.width > 231)
        m.imageMovie.uri = m.top.itemContent.providerLogo
    else
    ' Se restaura la imagen a la orignial
        m.imageMovie.uri = m.top.itemContent.poster
    end if

    m.focusImage.width = m.top.currRect.width
    m.focusImage.height = m.top.currRect.height


    m.imageMovie.width = m.top.currRect.width
    m.imageMovie.height = m.top.currRect.height
end sub


sub focusPercentChanged()
    print "focusPercent for item "; m.top.index; m.top.currTarget; m.top.focusPercent

    if ( m.top.focusPercent > 0.5)
        m.focusImage.visible = true
    else if (m.top.focusPercent < 0.5)
        m.focusImage.visible = false
    end if

    ' Si queremos opacidad al cambiar de item podemos hacerlo con esto
    ' focusPercent va aumentando su valor hasta que se le da el foco
    ' El problema es que a partir de 10 items algunos salen en negro hasta que se les da el foco
    ' if (m.top.currTarget > 0)
    '     m.imageMovie.opacity = m.top.currTarget
    ' end if
end sub