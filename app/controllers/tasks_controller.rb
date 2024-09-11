class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # GET /tasks
  def index
    # Ransackで検索結果を取得
    @q = Task.ransack(params[:q])

    # ステータスのデフォルトを指定なしに設定
    @status = params[:status].presence || ''
    
    # 期間検索のパラメータを取得
    q_params = params[:q] || {}
    start_date = q_params[:deadline_gteq].present? ? Date.parse(q_params[:deadline_gteq]) : nil
    end_date = q_params[:deadline_lteq].present? ? Date.parse(q_params[:deadline_lteq]) : nil

    # 検索結果を取得し、期間でフィルタリング
    @tasks = @q.result(distinct: true).within_date_range(start_date, end_date)

    # ステータスによる検索
    status_filter = params[:status_eq]
    @tasks = @tasks.where(status: status_filter) if status_filter.present?

    # 作成日時で昇順にソート
    @tasks = @tasks.order(created_at: :asc)
  end

  # GET /tasks/1
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to @task, notice: 'Task was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /tasks/1
  def update
    if @task.update(task_params)
      redirect_to @task, notice: 'Task was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /tasks/1
  def destroy
    @task.destroy
    redirect_to tasks_url, notice: 'Task was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def task_params
      params.require(:task).permit(:title, :description, :status, :deadline)
    end
end
