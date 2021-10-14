module ApplicationHelper
    def sort_helper text, col_name
        dir = 'asc'
        if params[:active_col] == col_name and params[:sort_dir] == 'asc'
            dir = 'desc'
        end
        link_to text, :active_col => col_name, :sort_dir => dir
    end
end
