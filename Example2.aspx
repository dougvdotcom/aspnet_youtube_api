<%@ Page Title="Displaying Selected YouTube Data API Thumbnails On A Web Page Via ASP.NET Web Forms" Language="VB" MasterPageFile="~/Default.master" AutoEventWireup="false" CodeFile="Example2.aspx.vb" Inherits="demos_youtube_data_api_thumbs_Example2" %>

<asp:Content ID="cntSidebar" ContentPlaceHolderID="cphSidebar" Runat="Server">
</asp:Content>
<asp:Content ID="cntMain" ContentPlaceHolderID="cphMain" Runat="Server">
    <!--
        Displaying Selected YouTube Data API Thumbnails On A Web Page Via ASP.NET Web Forms
        Copyright (C) 2012 Doug Vanderweide

        This program is free software: you can redistribute it and/or modify
        it under the terms of the GNU General Public License as published by
        the Free Software Foundation, either version 3 of the License, or
        (at your option) any later version.

        This program is distributed in the hope that it will be useful,
        but WITHOUT ANY WARRANTY; without even the implied warranty of
        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
        GNU General Public License for more details.

        You should have received a copy of the GNU General Public License
        along with this program.  If not, see <http://www.gnu.org/licenses/>.
    -->
    <h2>
        Displaying Selected YouTube Data API Thumbnails On A Web Page Via ASP.NET Web Forms
    </h2>

    <p class="note">
        This sample shows how to query the YouTube Data API with a search, retrieve relevant videos, and display hyperlinked thumbnails on a Web page.
    </p>

    <p><asp:Label runat="server" ID="lblStatus" Text="Status messages will appear here." /></p>
    <asp:Panel runat="server" ID="pnlThumbs" />

    <h4>Page Code</h4>

    <pre class="brush: xml">
        &lt;p&gt;&lt;asp:Label runat="server" ID="lblStatus" Text="Status messages will appear here." /&gt;&lt;/p&gt;
        &lt;asp:Panel runat="server" ID="pnlThumbs" /&gt;
    </pre>

    <h4>Code Behind</h4>

    <pre class="brush: vb">
        Sub Page_Load(Sender As Object, E As EventArgs) Handles Me.Load
	        MakeThumbnailLinks("YOUTUBE_DATA_API_DEVELOPER_KEY", "q=""Miss Maine""&amp;max-results=12&amp;duration=short&amp;safeSearch=strict&amp;orderby=relevance_lang_en")
        End Sub

        Function QueryYouTubeDataAPI(ByVal strAPIKey As String, ByVal strQuery As String) As XmlDocument
	        'Returns empty XMLDocument on failure, results XML on success
	        'This function requires your page to have a label control named lblStatus for error reporting

	        'build URL to shorten method resource
	        Dim strUri As New StringBuilder("https://gdata.youtube.com/feeds/api/videos?")
	        strUri.Append("v=2")
	        strUri.Append("&amp;")
	        strUri.Append(strQuery)
	        strUri.Append("&amp;key=")
	        strUri.Append(Server.HtmlEncode(strAPIKey))
	        strUri.Append("&amp;prettyprint=true") 'adds line breaks &amp; white space to response; useful for debugging

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
		        lblStatus.Text = "Error querying YouTube Data API. Message: " &amp; ex.Message
	        End Try

	        'send XML Document
	        Return objXML
        End Function

        Sub MakeThumbnailLinks(ByVal strAPIKey As String, ByVal strQuery As String)
	        'create XML document we will parse
	        Dim xmlDoc As New XmlDocument()
	        xmlDoc = QueryYouTubeDataAPI(strAPIKey, strQuery)

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
	            lblStatus.Text = "&amp;lt;strong&amp;gt;Request URL returned by YouTube Data API:&amp;lt;/strong&amp;gt; " &amp; Server.HtmlEncode(objNode.Attributes("href").Value)

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
    </pre>
</asp:Content>

