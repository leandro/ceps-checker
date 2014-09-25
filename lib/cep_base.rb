class CEPBase
  @@ceps_loaded = false
  @@db_conn     = nil
  @@ceps_source = "./db/ceps.txt"

  def self.include?(cep)
    load_ceps_into_db unless @@ceps_loaded
    normalized_cep = cep.to_s.strip.split('-').join('')[0, 8]
    !db.get_first_value("SELECT cep FROM ceps WHERE cep = '#{normalized_cep}'").nil?
  end

  def self.load_ceps_into_db
    create_table unless table_exists?

    lines_count = `wc -l #{@@ceps_source}`.strip.split(/\s+/).first.to_i
    rows_count  = db.get_first_value("SELECT COUNT(*) FROM ceps")
    return if (rows_count / lines_count.to_f) > 0.99

    (fp = File.new(@@ceps_source)).each_line do |line|
      cep = line.strip.split('-').join('')
      db.execute("INSERT INTO ceps(cep) VALUES(?)", cep) rescue nil
    end
    fp.close

    @@ceps_loaded = true
  end

  def self.db
    return @@db_conn if @@db_conn
    @@db_conn = SQLite3::Database.new "./db/ceps.db"
  end

  def self.create_table
    db.execute("CREATE TABLE ceps(cep CHAR(10) PRIMARY KEY)")
  end

  def self.table_exists?
    !db.get_first_row("PRAGMA table_info(ceps)").nil?
  end

end
