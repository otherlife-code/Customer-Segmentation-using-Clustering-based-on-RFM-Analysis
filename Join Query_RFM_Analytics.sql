-- Membuat Tabel Users

CREATE TABLE IF NOT EXISTS public.users
(
    id integer NOT NULL,
    first_name text COLLATE pg_catalog."default",
    last_name text COLLATE pg_catalog."default",
    email text COLLATE pg_catalog."default",
    age integer,
    gender text COLLATE pg_catalog."default",
    state text COLLATE pg_catalog."default",
    street_address text COLLATE pg_catalog."default",
    postal_code text COLLATE pg_catalog."default",
    city text COLLATE pg_catalog."default",
    country text COLLATE pg_catalog."default",
    latitude real,
    longitude real,
    traffic_source text COLLATE pg_catalog."default",
    created_at timestamp without time zone,
    CONSTRAINT users_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.users
    OWNER to postgres;
	
	
	
	
-- Membuat Tabel Order Items
	
CREATE TABLE IF NOT EXISTS public.order_items
(
    id integer NOT NULL,
    order_id integer,
    user_id integer,
    product_id integer,
    inventory_item_id integer,
    status text COLLATE pg_catalog."default",
    created_at timestamp without time zone,
    shipped_at timestamp without time zone,
    delivered_at timestamp without time zone,
    returned_at timestamp without time zone,
    sale_price real,
    CONSTRAINT order_items_id PRIMARY KEY (id),
    CONSTRAINT user_id FOREIGN KEY (user_id)
        REFERENCES public.users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.order_items
    OWNER to postgres;

COMMENT ON CONSTRAINT user_id ON public.order_items
    IS 'asda';
	
-- Index: fki_i

-- DROP INDEX IF EXISTS public.fki_i;

CREATE INDEX IF NOT EXISTS fki_i
    ON public.order_items USING btree
    (user_id ASC NULLS LAST)
    TABLESPACE pg_default;


--- Membuat tabel orders
CREATE TABLE public.product2
( 
    order_id integer,		
    user_id  real,	
    status text,	
    gender text,	
    created_at date,	
    returned_at date,
    shipped_at date,
    delivered_at date,	
    num_of_item integer
);




--- Membuat tabel product
CREATE TABLE public.product2
( 
    id integer,		
	cost real,	
	category text,	
	name text,	
	brand text,	
	retail_price real,	
	department text,
	sku text,	
	distribution_center_id integer
);

-- Membuat Tabel Customer_Analytics_Data hasil dari join table customer,order, order_items,dan product

CREATE TABLE Customer_Analytics_Data as (
  SELECT 
		U.id, U.first_name, 
		U.last_name, U.email, 
		U.age, U.gender,
		U.state, U.street_address,
		U.postal_code, U.city, U.country, 
		U.latitude, U.longitude, U.traffic_source, U.created_at as time_register, 
	    OI.id as order_items_id , OI.status, OI.created_at, OI.sale_price, OI.product_id,
		O.num_of_item, (OI.sale_price*O.num_of_item) as Total_Spend,
		PR.name AS product_name, PR.category AS product_category
	
	FROM users AS U
    Inner JOIN  order_items AS OI
	On U.id = OI.user_id
	Inner JOIN  orders AS O
	On O.order_id = OI.order_id
	Inner JOIN product AS  PR
	On PR.id = OI.product_id
	
	WHERE OI.status = 'Complete' 
    )
