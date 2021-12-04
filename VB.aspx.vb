Imports System.Data
Imports System.Data.SqlClient
Imports System.Collections
Imports System.Web.Services
Imports DAL

Partial Class VB
    Inherits System.Web.UI.Page
    Dim strConnString As String = ConfigurationManager.ConnectionStrings("conString").ConnectionString
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Me.BindData()

            'Dim dummy As DataTable = New DataTable()
            'dummy.Columns.Add("ContentTypeID")
            'dummy.Columns.Add("ContentDesc")
            'dummy.Columns.Add("Status")
            'dummy.Rows.Add()
            'gvCustomers.DataSource = dummy
            'gvCustomers.DataBind()

            ''Required for jQuery DataTables to work.
            'gvCustomers.UseAccessibleHeader = True
            'gvCustomers.HeaderRow.TableSection = TableRowSection.TableHeader
        End If
    End Sub

    Private Sub BindData()
        Dim strQuery As String = ("SELECT ContentTypeID, ContentDesc, Status FROM AT_Contents")
        Dim cmd As SqlCommand = New SqlCommand(strQuery)
        GridView1.DataSource = GetData(cmd)
        GridView1.DataBind()
    End Sub

    Private Function GetData(ByVal cmd As SqlCommand) As DataTable
        Dim dt As DataTable = New DataTable
        Dim con As SqlConnection = New SqlConnection(strConnString)
        Dim sda As SqlDataAdapter = New SqlDataAdapter
        cmd.Connection = con
        con.Open()
        sda.SelectCommand = cmd
        sda.Fill(dt)
        Return dt
    End Function

    Protected Sub OnPaging(ByVal sender As Object, ByVal e As GridViewPageEventArgs)
        Me.BindData()
        GridView1.PageIndex = e.NewPageIndex
        GridView1.DataBind()
    End Sub

    Protected Sub Edit(ByVal sender As Object, ByVal e As EventArgs)
        Dim row As GridViewRow = CType(CType(sender, LinkButton).Parent.Parent, GridViewRow)
        txtCustomerID.ReadOnly = True
        txtCustomerID.Text = row.Cells(0).Text
        txtContactName.Text = row.Cells(1).Text
        txtCompany.Text = row.Cells(2).Text
        popup.Show()
    End Sub

    Protected Sub Add(ByVal sender As Object, ByVal e As EventArgs)
        txtCustomerID.ReadOnly = False
        txtCustomerID.Text = String.Empty
        txtContactName.Text = String.Empty
        txtCompany.Text = String.Empty
        popup.Show()
    End Sub

    Protected Sub Save(ByVal sender As Object, ByVal e As EventArgs)
        Dim cmd As SqlCommand = New SqlCommand
        cmd.CommandType = CommandType.StoredProcedure
        cmd.CommandText = "AddUpdateCustomer"
        cmd.Parameters.AddWithValue("@CustomerID", txtCustomerID.Text)
        cmd.Parameters.AddWithValue("@ContactName", txtContactName.Text)
        cmd.Parameters.AddWithValue("@CompanyName", txtCompany.Text)
        GridView1.DataSource = Me.GetData(cmd)
        GridView1.DataBind()
    End Sub

    <WebMethod()>
    Public Shared Function GetTCUNotiList() As List(Of ContentModel)
        Dim customers As List(Of ContentModel) = New List(Of ContentModel)()
        Dim constr As String = ConfigurationManager.ConnectionStrings("constring").ConnectionString
        Using con As SqlConnection = New SqlConnection(constr)
            Using cmd As SqlCommand = New SqlCommand("SELECT ID, ContentTypeID, ContentTitle, ContentDesc, Status FROM AT_Contents", con)
                con.Open()
                Using sdr As SqlDataReader = cmd.ExecuteReader()
                    While sdr.Read()
                        customers.Add(New ContentModel With {
                            .ID = Convert.ToInt32(sdr("ID")),
                            .ContentTypeID = sdr("ContentTypeID").ToString(),
                            .ContentTitle = sdr("ContentTitle").ToString(),
                            .ContentDesc = sdr("ContentDesc").ToString(),
                            .Status = sdr("Status").ToString()
                        })
                    End While
                End Using
                con.Close()
            End Using
        End Using
        Return customers
    End Function
End Class
