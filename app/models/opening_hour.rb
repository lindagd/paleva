class OpeningHour < ApplicationRecord
  belongs_to :establishment

  enum :week_day, [ :sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday ]
  enum :status, [ :open, :closed ]

  validates :week_day, uniqueness: true
  validates_presence_of :week_day, message: 'deve ser selecionado'
  validates :open_time, :close_time, presence: true, if: -> {status == 'open'}
  validates :open_time, :close_time, absence: { if: -> {status == 'closed'}, message: "deve ficar em branco se 'Fechado' for marcado"}
  
end
