
Partial Class demos_youtube_data_api_thumbs_Default
    Inherits System.Web.UI.Page

    Sub Page_Load(Sender As Object, E As EventArgs) Handles Me.Load
        AddVideoThumbs()
    End Sub

    Sub AddVideoThumbs()
        'create ArrayList of known video IDs
        Dim arrIDs As New ArrayList
        arrIDs.Add("STxXS5lLunE")
        arrIDs.Add("Mwrl6bWfvrc")
        arrIDs.Add("4nTo8rjo-lM")
        arrIDs.Add("eVVXtknZVf0")
        arrIDs.Add("pxg113O_SRI")

        'some temp string variables for our processing loop
        Dim strTemp As String
        Dim strLink As String
        Dim strSrc As String

        For Each strTemp In arrIDs
            strSrc = "http://img.youtube.com/vi/" & strTemp & "/default.jpg" 'path to default thumbnail
            strLink = "http://www.youtube.com/watch?v=" & strTemp 'path to video on Youtube

            Dim objLink As New HyperLink 'create hyperlink
            objLink.NavigateUrl = strLink
            objLink.ImageUrl = strSrc
            objLink.Text = strTemp 'sets alt text to ensure XHTML compliance
            objLink.Target = "video" 'will open all videos in same, new window / tab
            objLink.CssClass = "margin-0-5" 'a specific-to-me CSS class to space out the thumbnails

            pnlThumbs.Controls.Add(objLink)
        Next
    End Sub

End Class
