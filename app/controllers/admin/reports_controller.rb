class Admin::ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy]

  def index
    @reports = Report.all
  end

  def show; end

  def new
    @report = Report.new
  end

  def edit; end

  def create
    @report = Report.new(report_params)

    if @report.save
      redirect_to admin_report_path(@report), notice: 'Report was successfully created.'
    else
      render :new
    end
  end

  def update
    if @report.update(report_params)
      redirect_to admin_report_path(@report), notice: 'Report was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @report.destroy
    redirect_to admin_reports_url, notice: 'Report was successfully destroyed.'
  end

  def sales_activity
    ReportsMailer.sales_activity.deliver_now
    redirect_to admin_url, notice: 'Sales Activity has been emailed to admins.'
  end

  private

  def set_report
    @report = Report.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:report_type, :start_date, :end_date, :totals?, :name, :last_run)
  end
end
