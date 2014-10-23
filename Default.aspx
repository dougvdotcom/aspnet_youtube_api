<%@ Page Title="Displaying Selected YouTube Video Thumbnails On An ASP.NET Web Forms Page" Language="VB" MasterPageFile="~/Default.master" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="demos_youtube_data_api_thumbs_Default" %>

<asp:Content ID="cntSidebar" ContentPlaceHolderID="cphSidebar" Runat="Server">
</asp:Content>
<asp:Content ID="cntMain" ContentPlaceHolderID="cphMain" Runat="Server">
    <!--
        Displaying Selected YouTube Video Thumbnails On An ASP.NET Web Forms Page
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
        Displaying Selected YouTube Video Thumbnails On An ASP.NET Web Forms Page
    </h2>
    <p class="note">
        This sample shows how to display thumbnails from known Youtube video IDs, which are hyperlinked to their player pages on youtube.com.
    </p>
    <asp:Panel runat="server" ID="pnlThumbs" />

    <h4>Page Code</h4>

    <pre class="brush: xml">
        &lt;asp:Panel runat="server" ID="pnlThumbs" /&gt;
    </pre>

    <h4>Code Behind</h4>

    <pre class="brush: vb">
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
    </pre>
</asp:Content>

