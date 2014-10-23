Imports System.Xml
Imports System.IO

Partial Class demos_youtube_data_api_thumbs_Example2
    Inherits System.Web.UI.Page

    Sub Page_Load(Sender As Object, E As EventArgs) Handles Me.Load
        MakeThumbnailLinks("YOUR API KEY", "q=""Miss Maine""&max-results=12&duration=short&safeSearch=strict&orderby=relevance_lang_en")
    End Sub

    Function QueryYouTubeDataAPI(ByVal strAPIKey As String, ByVal strQuery As String) As XmlDocument
        'Returns empty XMLDocument on failure, results XML on success
        'This function requires your page to have a label control named lblStatus for error reporting

        'build URL to shorten method resource
        Dim strUri As New StringBuilder("https://gdata.youtube.com/feeds/api/videos?")
        strUri.Append("v=2")
        strUri.Append("&")
        strUri.Append(strQuery)
        strUri.Append("&key=")
        strUri.Append(Server.HtmlEncode(strAPIKey))
        strUri.Append("&prettyprint=true") 'adds line breaks & white space to response; useful for debugging

        Dim objRequest As HttpWebRequest
        Dim objResponse As WebResponse
        Dim objXML As New XmlDocument() 'This is the document the function will return

        Try
            'create request for shorten resource
            objRequest = WebRequest.Create(strUri.ToString)
            'since we are passing querystring variables, our method is get
            objRequest.Method = "GET"
            'act as though we are sending a form
            objRequest.ContentType = "application/x-www-form-urlencoded"
            'don't wait for a 100 Continue HTTP response
            objRequest.ServicePoint.Expect100Continue = False
            'since we are using get, we need not send a request body; set content-length to 0
            objRequest.ContentLength = 0

            'read the Data API response into XML document
            objResponse = objRequest.GetResponse()
            objXML.Load(objResponse.GetResponseStream())
        Catch ex As Exception
            lblStatus.Text = "Error querying YouTube Data API. Message: " & ex.Message
        End Try

        'send XML Document
        Return objXML
    End Function

    Sub MakeThumbnailLinks(ByVal strAPIKey As String, ByVal strQuery As String)
        'create XML document we will parse
        Dim xmlDoc As New XmlDocument()
        xmlDoc = QueryYouTubeDataAPI(strAPIKey, strQuery)

        'must have child nodes to proceed
        If xmlDoc.HasChildNodes Then
            'add namespaces so we can traverse this thing
            Dim xmlNSM As New XmlNamespaceManager(xmlDoc.NameTable)
            xmlNSM.AddNamespace("atom", "http://www.w3.org/2005/Atom")
            xmlNSM.AddNamespace("media", "http://search.yahoo.com/mrss/")
            xmlNSM.AddNamespace("yt", "http://gdata.youtube.com/schemas/2007")

            'let's get our entry node values
            Dim xmlTitleNodes As XmlNodeList = xmlDoc.SelectNodes("/atom:feed/atom:entry/atom:title", xmlNSM)
            Dim xmlURLNodes As XmlNodeList = xmlDoc.SelectNodes("/atom:feed/atom:entry/media:group/media:player", xmlNSM)
            Dim xmlThumbNodes As XmlNodeList = xmlDoc.SelectNodes("/atom:feed/atom:entry/media:group/media:thumbnail[@yt:name='default']", xmlNSM)

            'for debugging, we'll also get the url that represents what the Data API actually used
            Dim objNode As XmlNode = xmlDoc.SelectSingleNode("/atom:feed/atom:link[@rel='self']", xmlNSM)
            lblStatus.Text = "<strong>Request URL returned by YouTube Data API:</strong> " & Server.HtmlEncode(objNode.Attributes("href").Value)

            'strings to store values
            Dim strTitle As String
            Dim strURL As String
            Dim strThumb As String

            'looping variable
            Dim I As Integer

            'For loop will iterate them; by definition, counts are the same for each XmlNodeList
            For I = 0 To xmlTitleNodes.Count - 1
                strTitle = xmlTitleNodes.Item(I).InnerText
                strURL = xmlURLNodes.Item(I).Attributes("url").Value
                strThumb = xmlThumbNodes.Item(I).Attributes("url").Value

                CreateHyperlinkedThumb(strTitle, strURL, strThumb)
            Next
        End If
    End Sub

    Sub CreateHyperlinkedThumb(strTitle As String, strURL As String, strThumb As String)
        'create hyperlink
        Dim ctlLink As New HyperLink()

        'set values
        ctlLink.Text = strTitle
        ctlLink.ToolTip = strTitle
        ctlLink.NavigateUrl = strURL
        ctlLink.ImageUrl = strThumb
        ctlLink.CssClass = "margin-5"
        ctlLink.Target = "video"

        'add to panel
        pnlThumbs.Controls.Add(ctlLink)
    End Sub

End Class
