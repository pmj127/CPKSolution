///MoonGrid with jquery and bootstrap
//Moonjoon Park
(function ($) {

    $.fn.moonGrid = function (options) {

        // Establish our default settings
        var settings = $.extend({
            pageNo: 1,
            pageSize: 10,
            searchText: null,
            filterText: null,
            orderColumn: null,
            orderDesc: null,
            url: null,
            sync: true,
            showPager: true,
            showSort: true,
            showSearcher: true,
            showModal: true
        }, options);
        var gridID = "";
        var ajaxSetting = {
            dataType: "json",
            method: "POST",
            url: settings.url,
            async: settings.sync,
            timeout: 30000,
            data: {
                "pageNo": settings.pageNo, "pageSize": settings.pageSize, "searchText": settings.searchText,
                "filterText": settings.filterText, "orderColumn": settings.orderColumn, "orderDesc": settings.orderDesc
            },
            success: function (data, status, jqXHR) {
                if (data.ErrorMessage != null) {
                    modalMessage("Error", data.ErrorMessage, true);
                    modalShow(true, true);
                    return;
                }
                //draw grid
                Grid.show(data);
                modalShow(false, settings.showModal);
            },
            error: function (xhr, status, errorThrown) {
                if (xhr.status == 403) {
                    var response = $.parseJSON(xhr.responseText);
                    window.location = response.LogInUrl;
                }
                else {
                    var errText = "";
                    switch (status) {
                        case "timeout":
                            errText = "Request timed out";
                            break;
                        case "error":
                            errText = errorThrown;
                            break;
                        case "abort":
                            errText = "Request aborted";
                            break;
                        case "parsererror":
                            errText = "Parser error";
                            break;
                    }
                    modalMessage("Error", errText, true);
                    modalShow(true, true);
                }
            }

        }
        function modalMessage( title, body, footer)
        {
            if(footer)
                $('#' + gridID + 'Modal .modal-footer').show();
            else
                $('#' + gridID + 'Modal .modal-footer').hide();

            $('#' + gridID + 'Modal .modal-title').text(title);
            var modalbody =$('#' + gridID + 'Modal .modal-body');
            modalbody.children().remove();
            if (body == "")
                modalbody.append('<div class="progress"><div class="progress-bar progress-bar-striped active" role="progressbar" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100" style="width: 100%"><span class="sr-only">Please wait for a while...</span></div></div>');
            else 
                modalbody.append('<p>'+ body + '</p>');
        }
        function modalShow(status, using)
        {
            if (using) {
                if (status)
                    $('#' + gridID + 'Modal').modal({ show: true, backdrop: 'static', keyboard: false });
                else
                    $('#' + gridID + 'Modal').modal('hide');
            }
        }
        var Grid = {
            show: function (jsonData) {
                function makeTd(value) {
                    return "<td>" + value + "</td>";
                }
                var table = $("#" + gridID + " > div > table > tbody");
                table.children().remove();
                if (jsonData.TotalRows == "0") {
                    var columnLength = $("#" + gridID + " > div > table > thead > tr > th").length;
                    table.append("<tr><td colspan='" + columnLength + "'> No Data...</td></tr>");
                }
                else {
                    var columns = $("#" + gridID + " > div > table > thead > tr > th");
                    $.each(jsonData.Rows, function (i) {
                        table.append("<tr/>");
                        var row = $("#" + gridID + " > div > table > tbody > tr").last();
                        columns.each(function () {
                            if ($(this).data("column") || ""){
                                row.append(makeTd(jsonData.Rows[i][$(this).data("column")]));
                                var column = row.children().last();

                                if ($(this).data("align") || "")
                                    column.css("text-align", $(this).data("align"));

                                if($(this).data("action") || "")
                                {
                                    var action = eval($(this).data("action"));
                                    column.click({ row: jsonData.Rows[i] }, action);
                                    column.css("cursor", "pointer");
                                }
                            }
                            else if ($(this).data("input-type") || "") {
                                row.append(makeTd("<input type='" + $(this).data("input-type") + "' />"));
                                var column = row.children().last();
                                column.css("text-align", "center");
                                var input = column.children(":input");
                                input.prop("name", gridID + $(this).data("input-type"));
                                if ($(this).data("input-value") || "")
                                    input.attr("data-value", jsonData.Rows[i][$(this).data("input-value")]);
                                if ($(this).data("action") || "") {
                                    var action = eval($(this).data("action"));
                                    input.change({ row: jsonData.Rows[i] }, action);
                                }
                            }
                        });

                    });
                }
                if (settings.showPager)
                    this.setPager(jsonData);
            },
            setPager: function (jsonData) {
                var pageNo = parseInt(jsonData.PageNo);
                var pageSize = parseInt(jsonData.PageSize);
                var totalRows = parseInt(jsonData.TotalRows);
                var totalPages = parseInt(totalRows / pageSize) + 1;
                var pager = $("#" + gridID).children("div:nth-child(3)");
                pager.children().remove();
                pager.append('<ul class="pager" style="display: inline-block;vertical-align: middle;" />');
                pager.append('<ul class="pagination" style="display: inline-block;vertical-align: middle; margin-left:5px; margin-right:5px;" />');
                pager.append('<ul class="pager" style="display: inline-block;vertical-align: middle;" />');
                pager.children("ul:nth-child(1)").append('<li class="previous" data-target="1"><a href="#">First</a></li>');
                pager.children("ul:nth-child(1)").append('<li class="previous" data-target="' + eval(pageNo - 1) + '"><a href="#">Previous</a></li>');
                pager.children("ul:nth-child(3)").append('<li class="next" data-target="' + totalPages + '"><a href="#">Last</a></li>');
                pager.children("ul:nth-child(3)").append('<li class="next" data-target="' + eval(pageNo + 1) + '"><a href="#">Next</a></li>');

                //first, previous
                if (pageNo == 1) {
                    pager.children("ul:nth-child(1)").children().first().addClass("disabled");
                    pager.children("ul:nth-child(1)").children().last().addClass("disabled");
                }
                //Last, next
                if (pageNo == totalPages) {
                    pager.children("ul:nth-child(3)").children().first().addClass("disabled");
                    pager.children("ul:nth-child(3)").children().last().addClass("disabled");
                }
                //numbers
                var startNo = 1;
                var endNo = 5;
                if (totalPages < 5)
                {
                    var endNo = totalPages;
                }
                else {
                    if (pageNo >= 3) {
                        startNo = pageNo - 2;
                        endNo = pageNo + 2;
                    }
                
                    if (pageNo >= totalPages - 2)
                        endNo = totalPages;
                }

                for (var i = startNo; i <= endNo; i++) {
                    if (i != pageNo)
                        pager.children("ul:nth-child(2)").append('<li data-target="' + i + '"><a href="#">' + i + '</a></li>');
                    else
                        pager.children("ul:nth-child(2)").append('<li class="disabled" data-target="' + i + '"><a href="#">' + i + '</a></li>');
                }

                $("#" + gridID + " > div:nth-child(3) > ul > li").not(".disabled").on("click", function () {
                    ajaxSetting.data.pageNo = $(this).data("target");
                    Grid.ajax();
                });
            },
            setSort: function () {
                $("#" + gridID + " > div > table > thead > tr > th[data-sort]").each(function () {
                    $(this).append('<a href="#" data-sortdirect="DESC"><span class="glyphicon glyphicon-arrow-down" style="font-size:.6em;" /></a>');
                    $(this).append('<a href="#" data-sortdirect="ASC"><span class="glyphicon glyphicon-arrow-up" style="font-size:.6em;" /></a>');
                    if ($(this).data("column") == settings.orderColumn)
                    {
                        switch(settings.orderDesc)
                        {
                            case "DESC" :
                                $(this).children("a:nth-child(1)").children().addClass("sorticoncolor");
                                break;
                            case "ASC" :
                                $(this).children("a:nth-child(1)").children().addClass("sorticoncolor");
                                break;
                        }
                    }

                    $(this).children().on("click", function () {
                        ajaxSetting.data.orderColumn = $(this).parent().data("column");
                        ajaxSetting.data.orderDesc = $(this).data("sortdirect");
                        Grid.ajax();
                        $("#" + gridID).find("span").removeClass("sorticoncolor");
                        $(this).children().addClass("sorticoncolor");
                    });;
                });
            },
            setSearcher: function () {
                $("#" + gridID + " > div:nth-child(1)").append('<div class="dropdown" style="display:inline-block;"><button class="btn btn-default dropdown-toggle" type="button" data-toggle="dropdown"><span>Page Size(10)</span><span class="caret"></span></button><ul class="dropdown-menu"><li><a href="#">5</a></li><li><a href="#">10</a></li><li><a href="#">15</a></li><li><a href="#">20</a></li><li><a href="#">25</a></li></ul></div>');
                var columnName = $("#" + gridID + " > div > table > thead > tr > th[data-search]").text();
                if (columnName != "") {
                    $("#" + gridID + " > div:nth-child(1)").first().append('<div class="input-group" style="width:300px;float:right"><span class="input-group-addon">Text</span><input type="text" class="form-control" name="msg" placeholder="search word"><div class="input-group-btn"><button class="btn btn-info" type="button"><i class="glyphicon glyphicon-search"></i></button></div></div>');
                    $("#" + gridID + " > div:nth-child(1) > div:nth-child(2) > span").text(columnName);
                    $("#" + gridID + " > div:nth-child(1) > div:nth-child(2) > input").val(settings.searchText);
                    $("#" + gridID + " > div:nth-child(1) > div:nth-child(2) > div > button").on("click", function () {
                        ajaxSetting.data.searchText = $("#" + gridID + " > div:nth-child(1) > div:nth-child(2) > input").val();
                        ajaxSetting.data.pageNo = 1;
                        Grid.ajax();
                    });
                }

                $("#" + gridID + " > div:nth-child(1) > div > button[data-toggle] > span:nth-child(1)").text("Page Size(" + settings.pageSize + ")");
                $("#" + gridID + " > div:nth-child(1) > div > ul > li").each(function () {
                    $(this).on("click", function () {
                        var size = $(this).children().text();
                        ajaxSetting.data.pageSize = size;
                        ajaxSetting.data.pageNo = 1;
                        $("#" + gridID + " > div:nth-child(1) > div > button[data-toggle] > span:nth-child(1)").text("Page Size(" + size + ")");
                        Grid.ajax();
                    });

                });
 
            },
            ajax: function () {
                modalMessage("Loading", "", false);
                modalShow(true, settings.showModal);
                $.ajax(ajaxSetting);
            }
        }

        return this.each(function () {
            gridID = $(this).prop("id");
            $(this).prepend('<div style="padding-bottom:2px;"></div>');
            $(this).append('<div align="center" ></div>');
            $(this).append('<div class="modal" id="' + gridID + 'Modal" role="dialog" style="padding-top: 20%;"><div class="modal-dialog"><div class="modal-content"><div class="modal-header"><h4 class="modal-title"></h4></div><div class="modal-body"></div><div class="modal-footer"><button type="button" class="btn btn-secondary" id="btn'+gridID+'Modal">Close</button></div></div></div></div>');
            $("#btn" + gridID + "Modal").on("click", function () {
                modalShow(false, true);
            });
            if (!settings.showPager){
                $(this).children("div:nth-child(3)")
            }

            if (settings.showSort) {
                Grid.setSort();
            }

            if (settings.showSearcher) {
                Grid.setSearcher();
            }
            else {
                $(this).children().first().hide();
            }   
            Grid.ajax();
        });

    }

}(jQuery));