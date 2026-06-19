const { Client } = require('pg');

const client = new Client({
  host: 'aws-0-ap-southeast-1.pooler.supabase.com',
  port: 6543,
  user: 'postgres.pwtgfygvnfmhzuikajhg',
  password: 'SNLbG4LYZmIr0d6D',
  database: 'postgres',
  ssl: {
    rejectUnauthorized: false
  }
});

const sql = `
CREATE TABLE IF NOT EXISTS products (
  id uuid default gen_random_uuid() primary key,
  owner_id varchar(255) not null,
  name varchar(255) not null,
  price bigint not null,
  normal_price bigint not null,
  category varchar(100) not null,
  condition varchar(50) not null,
  location text not null,
  description text not null,
  image_url text not null,
  status varchar(50) default 'Pending' not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

ALTER TABLE products ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Allow select for everyone" ON products;
CREATE POLICY "Allow select for everyone" ON products FOR SELECT USING (true);

DROP POLICY IF EXISTS "Allow all operations for everyone" ON products;
CREATE POLICY "Allow all operations for everyone" ON products FOR ALL USING (true) WITH CHECK (true);
`;

async function main() {
  console.log('Menghubungkan ke database Supabase Singapore Pooler...');
  try {
    await client.connect();
    console.log('Koneksi berhasil! Menjalankan query DDL untuk membuat tabel...');
    await client.query(sql);
    console.log('Tabel "products" dan kebijakan RLS berhasil dibuat!');
  } catch (err) {
    console.error('Terjadi kesalahan:', err);
  } finally {
    await client.end();
  }
}

main();
