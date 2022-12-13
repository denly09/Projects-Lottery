class Admin::CategoriesController < AdminController
    before_action :set_category, only: [:edit, :update, :destroy]

    def index
      @categories = Category.all
    end

    def new
      @category = Category.new
    end

    def create
      @category = Category.new(category_params)
      if @category.save
        flash[:notice] = 'Successfully saved'
        redirect_to admin_categories_path
      else
        render :new
      end
    end

    def edit ;end

    def update
      if @category.update(category_params)
        redirect_to admin_categories_path
      else
        render :edit
      end
    end

    def destroy
      @category.destroy
      if @category.deleted_at
        flash[:notice] = "Successfully Deleted"
      else
        flash[:alert] = "The item cannot be delete"
        redirect_to admin_categories_path
      end
    end

    private
    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit( :name)
    end
end

