# frozen_string_literal: true

class TodosController < ApplicationController
  include ExportDocument

  before_action :set_todo, only: %i[show edit update destroy clone]

  # GET /todos or /todos.json
  def index
    respond_to do |format|
      format.html
      format.json { render json: TodoDatatable.new(params, view_context: view_context) }
      format.csv { send_data Todo.to_csv, filename: filename('csv') }
      format.pdf { render_data(:pdf, { todos: Todo.includes(:items).all }) }
      format.docx { render_data(:docx, { todos: Todo.includes(:items).all }) }
      format.xlsx { render_data(:xlsx, { todos: Todo.includes(:items).all }) }
    end
  end

  # GET /todos/1 or /todos/1.json
  def show
    render 'todos/js/show'
  end

  # GET /todos/new
  def new
    @todo = Todo.new
    render 'todos/js/new'
  end

  # GET /todos/1/edit
  def edit
    render 'todos/js/edit'
  end

  # POST /todos or /todos.json
  def create
    @todo = Todo.new(todo_params)

    respond_to do |format|
      format.js { render 'todos/js/create' }
      if @todo.save
        format.html { redirect_to todo_url(@todo), notice: 'Todo was successfully created.' }
        format.json { render :show, status: :created, location: @todo }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /todos/1 or /todos/1.json
  def update
    respond_to do |format|
      format.js { render 'todos/js/update' }
      if @todo.update(todo_params)
        format.html { redirect_to todo_url(@todo), notice: 'Todo was successfully updated.' }
        format.json { render :show, status: :ok, location: @todo }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /todos/1 or /todos/1.json
  def destroy
    @todo.destroy

    respond_to do |format|
      format.js { render 'todos/js/destroy' }
      format.html { redirect_to todos_url, notice: 'Todo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def delete_all
    DeleteAllJob.perform_later(params[:ids])

    respond_to do |format|
      format.js { render 'todos/js/delete_all' }
      format.html { redirect_to todos_url, notice: 'Todos were successfully destroyed.' }
    end
  end

  def import
    TodoService.import(params[:file])

    render 'todos/js/import'
  end

  def clone
    @items = @todo.items.map(&:dup)
    @todo = @todo.dup
    @todo.items = @items

    render 'todos/js/clone'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_todo
    @todo = Todo.includes(:items).find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def todo_params
    params
      .require(:todo)
      .permit(
        :title,
        :description,
        :done, {
          items_attributes: %I[id description status _destroy]
        }
      )
  end
end
