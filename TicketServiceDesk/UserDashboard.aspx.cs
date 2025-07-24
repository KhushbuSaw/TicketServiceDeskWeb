using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TicketServiceDesk
{
    public partial class UserDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string email = Request.QueryString["email"];
                BindUserTicketsDetails(email);
            }
        }
        protected void BindUserTicketsDetails(string email)
        {
            string connStr = ConfigurationManager.ConnectionStrings["ServiceDeskConnectionString"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                string userDetailsQuery = "SELECT UserID FROM Users WHERE Email = @Email";
                SqlCommand getUserCommand = new SqlCommand(userDetailsQuery, con);
                getUserCommand.Parameters.AddWithValue("@Email", email);

                object result = getUserCommand.ExecuteScalar();

                if (result == null)
                {
                    return;
                }

                int userId = Convert.ToInt32(result);

                string query = @"
                SELECT TicketID, RaisedByUserName, RaisedByUserEmail, TicketType, Status, CreatedDate, DeliveryDate
                FROM Tickets
                WHERE AssignedToUserID = @AssignedToUserID";

                SqlCommand getTicketsCommand = new SqlCommand(query, con);
                getTicketsCommand.Parameters.AddWithValue("@AssignedToUserID", userId);

                SqlDataAdapter da = new SqlDataAdapter(getTicketsCommand);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvTickets.DataSource = dt;
                gvTickets.DataBind();
            }
        }
        protected void gvUserTickets_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                DateTime deliveryDate = Convert.ToDateTime(DataBinder.Eval(e.Row.DataItem, "DeliveryDate"));
                Label lblDaysLeft = (Label)e.Row.FindControl("lblDaysLeft");

                int daysLeft = (deliveryDate - DateTime.Now.Date).Days;

                if (daysLeft < 0)
                {
                    lblDaysLeft.Text = "Overshoot by " + Math.Abs(daysLeft) + " day";
                    lblDaysLeft.ForeColor = System.Drawing.Color.Red;
                }
                else
                {
                    lblDaysLeft.Text = daysLeft + " days left";
                    lblDaysLeft.ForeColor = System.Drawing.Color.Green;
                }
            }
        }
        protected void gvUserTickets_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditTicket")
            {
                string[] args = e.CommandArgument.ToString().Split('|');
                int ticketId = Convert.ToInt32(args[0]);
                string currentStatus = args[1];

                // Find the row and switch to edit mode
                GridViewRow row = ((Button)e.CommandSource).NamingContainer as GridViewRow;
                Label lblStatus = (Label)row.FindControl("lblStatus");
                DropDownList ddlStatus = (DropDownList)row.FindControl("ddlStatus");
                Button btnEdit = (Button)row.FindControl("btnEdit");
                Button btnSave = (Button)row.FindControl("btnSave");

                lblStatus.Visible = false;
                ddlStatus.Visible = true;
                btnEdit.Visible = false;
                btnSave.Visible = true;

                ddlStatus.SelectedValue = currentStatus;
            }
            else if (e.CommandName == "SaveTicket")
            {
                string[] args = e.CommandArgument.ToString().Split('|');
                int ticketId = Convert.ToInt32(args[0]);
                string email = args[1];

                GridViewRow row = ((Button)e.CommandSource).NamingContainer as GridViewRow;
                DropDownList ddlStatus = (DropDownList)row.FindControl("ddlStatus");

                string newStatus = ddlStatus.SelectedValue;

                string connStr = ConfigurationManager.ConnectionStrings["ServiceDeskConnectionString"].ConnectionString;
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    string updateQuery = "UPDATE Tickets SET Status = @Status WHERE TicketID = @TicketID";
                    SqlCommand cmd = new SqlCommand(updateQuery, con);
                    cmd.Parameters.AddWithValue("@Status", newStatus);
                    cmd.Parameters.AddWithValue("@TicketID", ticketId);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                BindUserTicketsDetails(email);
            }
        }


        protected void gvTickets_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}