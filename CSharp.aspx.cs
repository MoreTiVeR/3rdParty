using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using System.Collections;
using System.IO.Compression;  

public partial class _Default : System.Web.UI.Page 
{
private String strConnString = ConfigurationManager.ConnectionStrings["conString"].ConnectionString;
protected void Page_Load(object sender, EventArgs e)
{
    if (!IsPostBack)
    {
        this.BindData();
    }
}

private void BindData()
{
    string strQuery = "select CustomerID,ContactName,CompanyName" +
                       " from customers";
    SqlCommand cmd = new SqlCommand(strQuery);
    GridView1.DataSource = GetData(cmd);
    GridView1.DataBind();
}

private DataTable GetData(SqlCommand cmd)
{
    DataTable dt = new DataTable();
    using (SqlConnection con = new SqlConnection(strConnString))
    {
        using (SqlDataAdapter sda = new SqlDataAdapter())
        {
            cmd.Connection = con;
            con.Open();
            sda.SelectCommand = cmd;
            sda.Fill(dt);
            return dt;
        }
    }
}

    protected void OnPaging(object sender, GridViewPageEventArgs e)
    {
        this.BindData();
        GridView1.PageIndex = e.NewPageIndex;
        GridView1.DataBind();
    }

protected void Edit(object sender, EventArgs e)
{
    using (GridViewRow row = (GridViewRow)((LinkButton)sender).Parent.Parent)
    {
        txtCustomerID.ReadOnly = true;
        txtCustomerID.Text = row.Cells[0].Text;
        txtContactName.Text = row.Cells[1].Text;
        txtCompany.Text = row.Cells[2].Text;            
        popup.Show();
    }
}

protected void Add(object sender, EventArgs e)
{
    txtCustomerID.ReadOnly = false;
    txtCustomerID.Text = string.Empty;
    txtContactName.Text = string.Empty;
    txtCompany.Text = string.Empty;
    popup.Show();
}

protected void Save(object sender, EventArgs e)
{
    using (SqlCommand cmd = new SqlCommand())
    {
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.CommandText = "AddUpdateCustomer";
        cmd.Parameters.AddWithValue("@CustomerID", txtCustomerID.Text);
        cmd.Parameters.AddWithValue("@ContactName", txtContactName.Text);
        cmd.Parameters.AddWithValue("@CompanyName", txtCompany.Text);
        GridView1.DataSource =  this.GetData(cmd);
        GridView1.DataBind();
    }
}
}
