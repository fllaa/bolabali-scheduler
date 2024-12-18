CREATE TABLE IF NOT EXISTS "bolabali_account" (
	"user_id" varchar(255) NOT NULL,
	"type" varchar(255) NOT NULL,
	"provider" varchar(255) NOT NULL,
	"provider_account_id" varchar(255) NOT NULL,
	"refresh_token" text,
	"access_token" text,
	"expires_at" integer,
	"refresh_token_expires_in" integer,
	"token_type" varchar(255),
	"scope" varchar(255),
	"id_token" text,
	"session_state" varchar(255),
	CONSTRAINT "bolabali_account_provider_provider_account_id_pk" PRIMARY KEY("provider","provider_account_id")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "bolabali_job" (
	"id" integer PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY (sequence name "bolabali_job_id_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1),
	"name" varchar(255) NOT NULL,
	"description" text,
	"cronspec" varchar(255) NOT NULL,
	"url" varchar(255) NOT NULL,
	"method" varchar(255) NOT NULL,
	"headers" json,
	"body" json,
	"created_by" varchar(255) NOT NULL,
	"execute_at" timestamp with time zone NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "bolabali_log" (
	"id" integer PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY (sequence name "bolabali_log_id_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1),
	"job_id" integer NOT NULL,
	"status" varchar(255) NOT NULL,
	"response" json,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "bolabali_post" (
	"id" integer PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY (sequence name "bolabali_post_id_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1),
	"name" varchar(256),
	"created_by" varchar(255) NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "bolabali_session" (
	"session_token" varchar(255) PRIMARY KEY NOT NULL,
	"user_id" varchar(255) NOT NULL,
	"expires" timestamp with time zone NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "bolabali_user" (
	"id" varchar(255) PRIMARY KEY NOT NULL,
	"name" varchar(255),
	"email" varchar(255) NOT NULL,
	"email_verified" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
	"image" varchar(255)
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "bolabali_verification_token" (
	"identifier" varchar(255) NOT NULL,
	"token" varchar(255) NOT NULL,
	"expires" timestamp with time zone NOT NULL,
	CONSTRAINT "bolabali_verification_token_identifier_token_pk" PRIMARY KEY("identifier","token")
);
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "bolabali_account" ADD CONSTRAINT "bolabali_account_user_id_bolabali_user_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."bolabali_user"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "bolabali_job" ADD CONSTRAINT "bolabali_job_created_by_bolabali_user_id_fk" FOREIGN KEY ("created_by") REFERENCES "public"."bolabali_user"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "bolabali_log" ADD CONSTRAINT "bolabali_log_job_id_bolabali_job_id_fk" FOREIGN KEY ("job_id") REFERENCES "public"."bolabali_job"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "bolabali_post" ADD CONSTRAINT "bolabali_post_created_by_bolabali_user_id_fk" FOREIGN KEY ("created_by") REFERENCES "public"."bolabali_user"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "bolabali_session" ADD CONSTRAINT "bolabali_session_user_id_bolabali_user_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."bolabali_user"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "account_user_id_idx" ON "bolabali_account" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "job_created_by_idx" ON "bolabali_job" USING btree ("created_by");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "job_name_idx" ON "bolabali_job" USING btree ("name");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "log_job_id_idx" ON "bolabali_log" USING btree ("job_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "created_by_idx" ON "bolabali_post" USING btree ("created_by");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "name_idx" ON "bolabali_post" USING btree ("name");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "session_user_id_idx" ON "bolabali_session" USING btree ("user_id");