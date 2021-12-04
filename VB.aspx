<%@ Page Language="VB" AutoEventWireup="false" CodeFile="VB.aspx.vb" Inherits="VB" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>GridView Add, Edit, Delete AJAX Way</title>
    <link href="CSS/CSS.css" rel="stylesheet" type="text/css" />
    <link href="3rdParty/DataTables/datatables.css" type="text/css" rel="stylesheet" />

    <script src="scripts/jquery-1.10.2.js" type="text/javascript"></script>
    <script src="3rdParty/DataTables/datatables.js" type="text/javascript"></script>

    <script type="text/javascript">
        function Hidepopup() {
            $find("popup").hide();
            return false;
        }

        function ShowPopup() {
            $find("popup").show();
            return false;
        }
    </script>
    <script type="text/javascript">
        var dataTable;
        const createdCell = function (cell) {
            let original
            //cell.addEventListener("click", function () {
            //    this.classList.toggle("active");
            //    var content = this.nextElementSibling;
            //    if (content.style.maxHeight) {
            //        content.style.maxHeight = null;
            //    } else {
            //        content.style.maxHeight = content.scrollHeight + "px";
            //    }
            //});

            //celle.on("click", function () {
            //    $(this).prev("div").toggleClass('hide');
            //    if ($(this).text() == 'Show more') {
            //        $(this).text('Show Less');
            //    }
            //    else {
            //        $(this).text('Show more');
            //    }
            //});

            //cell.click(function () {
            //    $('#demo').toggleClass('open');
            //});

            //$('.toggleAbout h2').click(function () {
            //    alert('ddd');
            //    $('.about').slideToggle('slow', function () {
            //        $('.toggleAbout h2').toggle();
            //    });
            //})

            cell.addEventListener("click", function () {
                console.log(cell);
                $('.majorpoints').click(function () {
                    $('.hiders').toggle();
                });
            });

        }

        $(function () {
            //alert('CALL GetTCUNotiList');
            $.ajax({
                type: "POST",
                url: "VB.aspx/GetTCUNotiList",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnSuccess,
                failure: function (response) {
                    alert(response.d);
                },
                error: function (response) {
                    alert(response.d);
                }
            });
        });
        function OnSuccess(response) {
            //alert('OnSuccess' + response);
            dataTable = $('#tbItems').DataTable(
                {
                    paging: true,
                    destroy: true,
                    bLengthChange: true,
                    lengthMenu: [[5, 10, -1], [5, 10, "All"]],
                    bFilter: true,
                    bSort: true,
                    bPaginate: true,
                    data: response.d,
                    columns: [
                        {
                            'data': 'ContentTypeID',
                            "render": function (data) {
                                return "<div style='text-align: center'>" + data + "</div>";
                            }
                        },
                        {
                            'data': { ID: 'ID', ContentTitle: 'ContentTitle', ContentDesc: 'ContentDesc' },
                            "render": function (data) {

                                var cTitle = data.ContentTitle;
                                var cDesc = data.ContentDesc;
                                if (data.ContentTitle > 200) {
                                    console.log('ContentTitle length > 200');
                                    cTitle = data.ContentTitle.substring(1, 200);
                                }
                                if (data.ContentDesc.length > 4000) {
                                    console.log('ContentDesc length > 4000');
                                    cDesc = data.ContentDesc.substring(1, 4000);
                                }

                                return "<details><summary>" + cTitle + "</summary><p>" + cDesc + "</p></details>";
                                /*return "<button type='button' data-target='#demo' data-toggle='collapse'>Collapsible</button><div id='demo' class='collapse''><p>" + data + "</p></div>";*/
                                /*return "<div class='toggleAbout'><h2 class='toggleOff'>Click</h2><h2 class='toggleOn'>Close</h2></div><div class='about'><p>blah blah blah</p></div>";*/

                                //3
                                //return "<div class='majorpoints_" + data.ID + "' onclick='ShowText(" + data.ID + ")'>[TITLE_X]</div><div class='hiders_" + data.ID + "' style='display:none' >" + data.ContentDesc + "</div>";
                                /*return "<div class='majorpoints_" + data.ID + "'>[TITLE_X]</div><div class='hiders_" + data.ID + "' style='display:none' >" + data.ContentDesc + "</div>";*/

                            }
                        },
                        {
                            "data": "IsStatus",
                            "render": function (data) {
                                if (data) {
                                    return "<div style='text-align: center'><input type='checkbox' checked='" + data + "' onclick='return false;'><span class='checkmark'></span></div>";
                                }
                                return "<div style='text-align: center'><input type='checkbox' onclick='return false;'><span class='checkmark'></span></div>";
                            }
                        }
                    ],
                    //columnDefs: [
                    //    {
                    //        targets: [1],
                    //        createdCell: createdCell
                    //        //visible: true
                    //    }
                    //],
                    language: {
                        "emptyTable": "ไม่พบข้อมูล.",
                        "paginate": {
                            "first": "หน้าแรก",
                            "last": "หน้าสุดท้าย",
                            "next": "ถัดไป",
                            "previous": "ก่อนหน้า",
                        },
                        "info": "แสดงรายการ _START_ ถึง _END_ จาก _TOTAL_ รายการ",
                        "infoEmpty": "แสดงรายการ 0 to 0 of 0 รายการ",
                        "search": "ค้นหา:",
                        "zeroRecords": "ไม่พบรายการที่ค้นหา",
                        "lengthMenu": "แสดง _MENU_ รายการ",
                    }
                });
        };

    </script>

    <script type="text/javascript">

        $(document).ready(function () {
            //$('.majorpoints').click(function () {
            //    $('.hiders').toggle();
            //});
        });

        function ShowText(id) {
            /*alert(id);*/
            $('.majorpoints_' + id + '').click(function () {
                $('.hiders_' + id + '').toggle();
                /*$('.hiders_' + id + '').show();*/
                /*$('.hiders_' + id + '').css('display', 'block');*/
            });
        }

        var coll = document.getElementsByClassName("collapsible");
        for (i = 0; i < coll.length; i++) {
            coll[i].addEventListener("click", function () {
                this.classList.toggle("active");
                var content = this.nextElementSibling;
                if (content.style.maxHeight) {
                    content.style.maxHeight = null;
                } else {
                    content.style.maxHeight = content.scrollHeight + "px";
                }
            });
        }
    </script>
</head>
<body style="margin: 0; padding: 0">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <asp:GridView ID="GridView1" runat="server" Width="550px"
                    AutoGenerateColumns="false" Font-Names="Arial"
                    Font-Size="11pt" AlternatingRowStyle-BackColor="#C2D69B"
                    HeaderStyle-BackColor="green" AllowPaging="true" ShowFooter="true"
                    OnPageIndexChanging="OnPaging"
                    PageSize="10">
                    <Columns>
                        <asp:BoundField DataField="ContentTypeID" HeaderText="ContentTypeID" HtmlEncode="true" />
                        <asp:BoundField DataField="ContentDesc" HeaderText="ContentDesc" HtmlEncode="true" />
                        <asp:BoundField DataField="Status" HeaderText="Status" HtmlEncode="true" />
                        <asp:TemplateField ItemStyle-Width="30px" HeaderText="ID">
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" OnClick="Edit"></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <AlternatingRowStyle BackColor="#C2D69B" />
                </asp:GridView>
                <asp:Button ID="btnAdd" runat="server" Text="Add" OnClick="Add" />
                <asp:Panel ID="pnlAddEdit" runat="server" CssClass="modalPopup" Style="display: none">
                    <asp:Label Font-Bold="true" ID="Label4" runat="server" Text="Customer Details"></asp:Label>
                    <br />
                    <table align="center">
                        <tr>
                            <td>
                                <asp:Label ID="Label1" runat="server" Text="CustomerId"></asp:Label>
                            </td>
                            <td>
                                <asp:TextBox ID="txtCustomerID" Width="40px" MaxLength="5" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="Label2" runat="server" Text="Contact Name"></asp:Label>
                            </td>
                            <td>
                                <asp:TextBox ID="txtContactName" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="Label3" runat="server" Text="Company"></asp:Label>
                            </td>
                            <td>
                                <asp:TextBox ID="txtCompany" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="Save" />
                            </td>
                            <td>
                                <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClientClick="return Hidepopup()" />
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
                <asp:LinkButton ID="lnkFake" runat="server"></asp:LinkButton>
                <cc1:ModalPopupExtender ID="popup" runat="server" DropShadow="false"
                    PopupControlID="popupTCUStatus" TargetControlID="lnkFake"
                    BackgroundCssClass="modalBackground">
                </cc1:ModalPopupExtender>
            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="GridView1" />
                <asp:AsyncPostBackTrigger ControlID="btnSave" />
            </Triggers>
        </asp:UpdatePanel>
        <asp:Panel ID="popupTCUStatus" runat="server" Style="display: none">
            <%--<asp:GridView ID="gvCustomers" runat="server" CssClass="display compact" AutoGenerateColumns="false">
                <Columns>
                    <asp:BoundField DataField="ContentTypeID" HeaderText="ContentTypeID" />
                    <asp:BoundField DataField="ContentDesc" HeaderText="ContentDesc" />
                    <asp:BoundField DataField="Status" HeaderText="Status" />
                </Columns>
            </asp:GridView>--%>
            <div class="table-responsive">
                <table id="tbItems" class="table" style="width: 100%">
                    <thead>
                        <tr>
                            <%--<th class="wd-15p" style="visibility: hidden">ลำดับ</th>--%>
                            <th class="wd-15p">ลำดับ</th>
                            <th class="wd-15p">ชื่อที่ต้องการสลัก</th>
                            <th class="wd-15p">ลาย</th>
                        </tr>
                    </thead>
                </table>
            </div>
        </asp:Panel>
    </form>

    <!-- Accordion start -->
                <section id="accordionWrapa">
                    <h4 class="mt-3">Accordion</h4>
                    <p>
                        Using the <code>card</code> component you can extend the default collapse behavior to create an
                        accordion. To properly achieve the accordion style, be sure to use <code>.accordion</code> as a wrapper for get
                        Template specific style..
                    </p>
                    <div class="accordion" id="accordionWrapa1">
                        <div class="card collapse-header">
                            <div id="heading1" class="card-header" role="tablist" data-toggle="collapse" data-target="#accordion1" aria-expanded="false" aria-controls="accordion1">
                                <span class="collapse-title">Accordion Item 1</span>
                            </div>
                            <div id="accordion1" role="tabpanel" data-parent="#accordionWrapa1" aria-labelledby="heading1" class="collapse">
                                <div class="card-body">
                                    Cheesecake cotton candy bonbon muffin cupcake tiramisu croissant. Tootsie roll sweet candy bear
                                    claw chupa chups lollipop toffee. Macaroon donut liquorice powder candy carrot cake macaroon
                                    fruitcake. Cookie toffee lollipop cotton candy ice cream dragée soufflé.
                                    Cake tiramisu lollipop wafer pie soufflé dessert tart. Biscuit ice cream pie apple pie topping
                                    oat cake dessert. Soufflé icing caramels. Chocolate cake icing ice cream macaroon pie cheesecake
                                    liquorice apple pie.
                                </div>
                            </div>
                        </div>
                        <div class="card collapse-header">
                            <div id="heading2" class="card-header" data-toggle="collapse" role="button" data-target="#accordion2" aria-expanded="false" aria-controls="accordion2">
                                <span class="collapse-title">Accordion Item 2</span>
                            </div>
                            <div id="accordion2" role="tabpanel" data-parent="#accordionWrapa1" aria-labelledby="heading2" class="collapse" aria-expanded="false">
                                <div class="card-body">
                                    Pie pudding candy. Oat cake jelly beans bear claw lollipop. Ice cream candy canes tootsie roll
                                    muffin powder donut powder. Topping candy canes chocolate bar lemon drops candy canes.
                                    Halvah muffin marzipan powder sugar plum donut donut cotton candy biscuit. Wafer jujubes apple
                                    pie sweet lemon drops jelly cupcake. Caramels dessert halvah marshmallow. Candy topping cotton
                                    candy oat cake croissant halvah gummi bears toffee powder.
                                </div>
                            </div>
                        </div>
                        <div class="card collapse-header">
                            <div id="heading3" class="card-header" data-toggle="collapse" role="button" data-target="#accordion3" aria-expanded="false" aria-controls="accordion3">
                                <span class="collapse-title">Accordion Item 3</span>
                            </div>
                            <div id="accordion3" role="tabpanel" data-parent="#accordionWrapa1" aria-labelledby="heading3" class="collapse" aria-expanded="false">
                                <div class="card-body">
                                    Gingerbread liquorice liquorice cake muffin lollipop powder chocolate cake. Gummi bears lemon
                                    drops toffee liquorice pastry cake caramels chocolate bar brownie. Sweet biscuit chupa chups
                                    sweet.
                                    Halvah fruitcake gingerbread croissant dessert cupcake. Chupa chups chocolate bar donut tart.
                                    Donut cake dessert cookie. Ice cream tootsie roll powder chupa chups pastry cupcake soufflé.
                                </div>
                            </div>
                        </div>
                        <div class="card collapse-header">
                            <div id="heading4" class="card-header" data-toggle="collapse" role="button" data-target="#accordion4" aria-expanded="false" aria-controls="accordion4">
                                <span class="collapse-title">Accordion Item 4</span>
                            </div>
                            <div id="accordion4" role="tabpanel" data-parent="#accordionWrapa1" aria-labelledby="heading4" class="collapse" aria-expanded="false">
                                <div class="card-body">
                                    Icing sweet roll cotton candy brownie candy canes candy canes. Pie jelly dragée pie. Ice cream
                                    jujubes wafer. Wafer croissant carrot cake wafer gummies gummies chupa chups halvah bonbon.
                                    Gummi bears cotton candy jelly-o halvah. Macaroon apple pie dragée bonbon marzipan cheesecake.
                                    Jelly jelly beans marshmallow.
                                </div>
                            </div>
                        </div>
                    </div>
                </section>
                <!-- Accordion end -->
</body>
</html>
