#-- copyright
# OpenProject Backlogs Plugin
#
# Copyright (C)2013-2014 the OpenProject Foundation (OPF)
# Copyright (C)2011 Stephan Eckardt, Tim Felgentreff, Marnen Laibow-Koser, Sandro Munda
# Copyright (C)2010-2011 friflaj
# Copyright (C)2010 Maxime Guilbot, Andrew Vit, Joakim Kolsjö, ibussieres, Daniel Passos, Jason Vasquez, jpic, Emiliano Heyns
# Copyright (C)2009-2010 Mark Maglana
# Copyright (C)2009 Joe Heck, Nate Lowrie
#
# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License version 3.
#
# OpenProject Backlogs is a derivative work based on ChiliProject Backlogs.
# The copyright follows:
# Copyright (C) 2010-2011 - Emiliano Heyns, Mark Maglana, friflaj
# Copyright (C) 2011 - Jens Ulferts, Gregor Schmidt - Finn GmbH - Berlin, Germany
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See doc/COPYRIGHT.rdoc for more details.
#++


class RbExportCardConfigurationsController < RbApplicationController
  include OpenProject::PdfExport::ExportCard

  before_filter :load_project_and_sprint

  def index
    @configs = ExportCardConfiguration.active
  end

  def show
    config = ExportCardConfiguration.find(params[:id])

    cards_document = OpenProject::PdfExport::ExportCard::DocumentGenerator.new(config, @sprint.stories(@project))

    filename = "#{@project.to_s}-#{@sprint.to_s}-#{Time.now.strftime("%B-%d-%Y")}.pdf"
    respond_to do |format|
      format.pdf { send_data(cards_document.render,
        disposition: 'attachment',
        type: 'application/pdf',
        filename: filename) }
    end
  end

  private

  def load_project_and_sprint
    @project = Project.find(params[:project_id])
    @sprint = Sprint.find(params[:sprint_id])
  end
end
