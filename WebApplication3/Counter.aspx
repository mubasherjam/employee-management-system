<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Counter.aspx.cs" Inherits="WebApplication3.Counter" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Label ID="CounterOP" runat="server"> </asp:Label>
            <p>
                <asp:Button ID="Add" runat="server" Text="Add" OnClick="Add_Click" />
            </p>
        </div>
    </form>
</body>
</html>