-- ================================================================
-- LI ZHENG AUTOMOBILE — Supabase Schema
-- Run this in Supabase SQL Editor
-- ================================================================

-- Cars table
create table if not exists cars (
  id            uuid primary key default gen_random_uuid(),
  make          text not null,
  model         text not null,
  year          int not null,
  price         numeric not null default 0,
  price_label   text not null,
  body_type     text,
  fuel_type     text,
  transmission  text,
  color         text,
  engine_cc     text,
  seats         int,
  mileage       int not null default 0,
  description   text,
  features      text[] default '{}',
  images        text[] default '{}',
  walkround_url text,
  status        text not null default 'available' check (status in ('available','sold','reserved')),
  featured      boolean not null default false,
  views         int not null default 0,
  created_at    timestamptz not null default now()
);

-- Spare parts table
create table if not exists spare_parts (
  id          uuid primary key default gen_random_uuid(),
  name        text not null,
  category    text not null,
  price       numeric,
  price_label text,
  compatible  text,
  description text,
  image       text,
  in_stock    boolean not null default true,
  created_at  timestamptz not null default now()
);

-- Inquiries table
create table if not exists inquiries (
  id          uuid primary key default gen_random_uuid(),
  type        text not null default 'general',
  car_id      uuid references cars(id) on delete set null,
  car_name    text,
  name        text not null,
  phone       text not null,
  email       text,
  message     text,
  handled     boolean not null default false,
  created_at  timestamptz not null default now()
);

-- Testimonials table
create table if not exists testimonials (
  id          uuid primary key default gen_random_uuid(),
  name        text not null,
  initials    text,
  car_label   text,
  message     text not null,
  approved    boolean not null default false,
  created_at  timestamptz not null default now()
);

-- ── Row Level Security ──────────────────────────────────
alter table cars enable row level security;
alter table spare_parts enable row level security;
alter table inquiries enable row level security;
alter table testimonials enable row level security;

create policy "Public read cars" on cars for select using (true);
create policy "Public read parts" on spare_parts for select using (true);
create policy "Public insert inquiries" on inquiries for insert with check (true);
create policy "Public read inquiries" on inquiries for select using (true);
create policy "Public read approved testimonials" on testimonials for select using (approved = true);
create policy "Public insert testimonials" on testimonials for insert with check (true);

-- ── Seed demo cars ──────────────────────────────────────
insert into cars (make, model, year, price, price_label, body_type, fuel_type, transmission, color, engine_cc, seats, mileage, description, features, images, status, featured) values
(
  'BYD', 'Atto 3', 2024, 32000000, 'RWF 32,000,000',
  'SUV', 'Electric', 'Automatic', 'Pearl White', 'Electric 150kW', 5, 0,
  'The BYD Atto 3 is a fully electric compact SUV packed with cutting-edge technology. With a 60.5 kWh battery delivering up to 420km range, it redefines what an electric SUV can be in Kigali.',
  ARRAY['420km Range','Fast Charging','Panoramic Sunroof','360° Camera','Heated Seats','Wireless CarPlay','8-Speaker Sound','OTA Updates'],
  ARRAY['https://images.unsplash.com/photo-1555215695-3004980ad54e?w=900&q=80','https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?w=900&q=80','https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?w=900&q=80'],
  'available', true
),
(
  'Chery', 'Tiggo 8 Pro', 2024, 28500000, 'RWF 28,500,000',
  'SUV', 'Petrol', 'Automatic', 'Midnight Black', '1.6T 197hp', 7, 0,
  'The Chery Tiggo 8 Pro is a 7-seater family SUV with turbocharged performance and a premium interior. Features a 12.3-inch digital cockpit and Level 2 ADAS driver assistance.',
  ARRAY['7 Seats','1.6T Turbo','12.3" Digital Cockpit','ADAS Level 2','360° Camera','Leather Seats','Ventilated Seats','Ambient Lighting'],
  ARRAY['https://images.unsplash.com/photo-1494976388531-d1058494cdd8?w=900&q=80','https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=900&q=80'],
  'available', true
),
(
  'Haval', 'H6', 2023, 24000000, 'RWF 24,000,000',
  'SUV', 'Hybrid', 'Automatic', 'Titanium Silver', '1.5T HEV', 5, 0,
  'The Haval H6 DHT Hybrid combines a 1.5T engine with a 130kW electric motor for exceptional fuel efficiency. Up to 1000km on a single tank — the perfect city and highway SUV.',
  ARRAY['Hybrid DHT','1000km Range','ADAS','10.25" Display','Wireless Charging','Push Button Start','Keyless Entry','Cruise Control'],
  ARRAY['https://images.unsplash.com/photo-1609521263047-f8f205293f24?w=900&q=80','https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=900&q=80'],
  'available', true
),
(
  'BYD', 'Seal', 2024, 38000000, 'RWF 38,000,000',
  'Sedan', 'Electric', 'Automatic', 'Cosmos Black', 'Electric 230kW', 5, 0,
  'The BYD Seal is a performance electric sedan with blade battery technology. 0-100km/h in 3.8 seconds, 570km range, and a stunning ocean-inspired design.',
  ARRAY['570km Range','0-100 in 3.8s','Blade Battery','Vehicle-to-Load','HUD Display','Adaptive Cruise','Ventilated Seats','12-speaker Audio'],
  ARRAY['https://images.unsplash.com/photo-1617788138017-80ad40651399?w=900&q=80','https://images.unsplash.com/photo-1544636331-e26879cd4d9b?w=900&q=80'],
  'available', false
),
(
  'Chery', 'Arrizo 8', 2023, 19500000, 'RWF 19,500,000',
  'Sedan', 'Petrol', 'Automatic', 'Glacier White', '1.6T 147hp', 5, 0,
  'The Chery Arrizo 8 is a stylish mid-size sedan offering a premium feel at an accessible price. Spacious interior, smooth turbocharged engine, and a well-equipped feature list.',
  ARRAY['1.6T Engine','10.25" Touchscreen','Leather Interior','Reverse Camera','Lane Keep Assist','Auto Headlights','Keyless Entry','6-speaker Audio'],
  ARRAY['https://images.unsplash.com/photo-1580273916550-e323be2ae537?w=900&q=80'],
  'available', false
),
(
  'Haval', 'Jolion', 2024, 21000000, 'RWF 21,000,000',
  'SUV', 'Petrol', 'Automatic', 'Flame Red', '1.5T 147hp', 5, 0,
  'The Haval Jolion is a bold compact SUV built for young drivers. Sporty styling, a 1.5T turbocharged engine, and an advanced driver assistance suite make it a standout choice.',
  ARRAY['1.5T Turbo','ADAS','10.25" Display','360° Camera','Wireless CarPlay','Push Start','Keyless Entry','Sport Mode'],
  ARRAY['https://images.unsplash.com/photo-1485291571150-772bcfc10da5?w=900&q=80','https://images.unsplash.com/photo-1469285994282-454ceb49e63c?w=900&q=80'],
  'available', true
);

-- ── Seed spare parts ────────────────────────────────────
insert into spare_parts (name, category, price, price_label, compatible, description, in_stock) values
('BYD Atto 3 Front Bumper', 'Body', 850000, 'RWF 850,000', 'BYD Atto 3 2022-2024', 'OEM front bumper assembly', true),
('Chery Tiggo Engine Air Filter', 'Engine', 45000, 'RWF 45,000', 'Chery Tiggo 4/7/8 1.5T', 'Genuine engine air filter', true),
('Haval H6 Brake Pads (Front)', 'Brakes', 120000, 'RWF 120,000', 'Haval H6 2020-2024', 'OEM front brake pad set', true),
('BYD Seal Headlight Assembly', 'Electrical', 1200000, 'RWF 1,200,000', 'BYD Seal 2022-2024', 'Full LED headlight unit', true),
('Chery Arrizo Shock Absorber', 'Suspension', 380000, 'RWF 380,000', 'Chery Arrizo 5/6/8', 'Front shock absorber (each)', true),
('Universal Floor Mats (Set of 4)', 'Interior', 65000, 'RWF 65,000', 'Universal fit', 'All-weather rubber floor mats', true);
