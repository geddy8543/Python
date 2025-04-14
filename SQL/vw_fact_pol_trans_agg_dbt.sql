with
    mx_rec as (
        select
            row_number() over (
                partition by f.bright_policy_id, f.policy_term
                order by
                    f.snapshot_start_date desc,
                    f.snapshot_end_date desc,
                    f.replication_datetime desc
            ) as rank,
            f.snapshot_start_date snp_st,
            f.snapshot_end_date snp_end,
            f.*,
            a.state,
            pr.product_line,
            c.insurance_carrier_name,
            p.policy_status
        from {{ ref("fact_policy_transactions_gold") }} f
        left join {{ ref("dim_addresses_gold") }} a on f.address_key = a.address_key
        left join {{ ref("dim_policies_gold") }} p on f.policy_key = p.policy_key
        left join {{ ref("dim_products_gold") }} pr on f.product_key = pr.product_key
        left join
            {{ ref("dim_insurance_carriers_gold") }} c
            on f.insurance_carrier_key = c.insurance_carrier_key  -- where
        where f.snapshot_start_date < current_date()
    ),
    details as (
        select
            bright_policy_id,
            full_policy_number,
            policy_term,
            f.policy_effective_date,
            f.policy_expiration_date,
            f.policy_final_term_date,
            f.policy_status,
            state,
            product_line,
            insurance_carrier_name,
            case
                when
                    rank = 1  -- and policy_status <> 'cancelled'
                    and snapshot_end_date < cast(policy_final_term_date as date)
                then cast(policy_final_term_date as date)  -- snapshot_end_date
                else snapshot_end_date
            end as snapshot_end_date_use,
            amt_multiplier,
            datediff(
                day, snapshot_start_date, snapshot_end_date
            ) as snapshot_start_end_days,
            f.policy_snapshot_days,
            datediff(
                day,
                snapshot_start_date,
                least(cast(snapshot_end_date as date), current_date())
            ) as snapshot_earned_days,
            policy_snapshot_days,
            full_term_policy_days,
            cast(snapshot_earned_days as decimal)
            / cast(full_term_policy_days as decimal) as earned_exposures,
            (snapshot_earned_days / full_term_policy_days) as expected_earned_exposures,
            frozen_rating_output_premium
            - frozen_rating_output_ledger_c_rates_total as premium,
            f.frozen_rating_output_ledger_a_rates_total
            + f.frozen_rating_output_ledger_b_rates_total as total_premium,
            f.frozen_rating_output_ledger_a_rates_total
            + frozen_rating_output_ledger_b_rates_total as total_premium_accrual,
            frozen_rating_output_ledger_a_rates_hurricane
            + frozen_rating_output_ledger_b_rates_hurricane
            as hurricane_premium_accrual,
            frozen_rating_output_ledger_a_rates_fire
            + frozen_rating_output_ledger_b_rates_fire as fire_premium_accrual,
            frozen_rating_output_ledger_flood_rates_total as flood_premium_accrual,
            (
                frozen_rating_output_ledger_a_rates_earthquake
                + frozen_rating_output_ledger_a_rates_earthquake_1
                + frozen_rating_output_ledger_a_rates_earthquake_2
                + frozen_rating_output_ledger_a_rates_earthquake_3
                + frozen_rating_output_ledger_b_rates_earthquake
                + frozen_rating_output_ledger_b_rates_earthquake_1
                + frozen_rating_output_ledger_b_rates_earthquake_2
                + frozen_rating_output_ledger_b_rates_earthquake_3
            ) as earthquake_premium_accrual,
            (
                frozen_rating_output_ledger_a_rates_wild_fire
                + frozen_rating_output_ledger_a_rates_wild_fire_1
                + frozen_rating_output_ledger_a_rates_wild_fire_2
                + frozen_rating_output_ledger_a_rates_wild_fire_3
                + frozen_rating_output_ledger_b_rates_wild_fire
                + frozen_rating_output_ledger_b_rates_wild_fire_1
                + frozen_rating_output_ledger_b_rates_wild_fire_2
                + frozen_rating_output_ledger_b_rates_wild_fire_3
            ) as wild_fire_premium_accrual,
            frozen_rating_output_ledger_a_rates_winter_storm
            + frozen_rating_output_ledger_b_rates_winter_storm
            as winter_storm_premium_accrual,
            frozen_rating_output_ledger_a_rates_severe_convective_storm
            + frozen_rating_output_ledger_b_rates_severe_convective_storm
            as severe_convective_storm_premium_accrual,
            frozen_rating_output_ledger_a_rates_all_other_perils
            + frozen_rating_output_ledger_b_rates_all_other_perils
            as all_other_perils_premium_accrual,
            (
                frozen_rating_output_ledger_c_rates_total
            ) as additional_surplus_and_fees_accrual,
            (frozen_rating_output_ledger_c_calculations_surplus) as surplus_accrual,
            (frozen_rating_output_ledger_c_calculations_surcharge) as surcharge_accrual,
            (
                frozen_rating_output_ledger_c_calculations_installment_fee
            ) as installment_feedaily_accrual,
            (
                frozen_rating_output_ledger_c_calculations_inspection_fee
            ) as inspection_feedaily_accrual,
            (frozen_rating_output_ledger_c_calculations_empt_fee) as empt_fee_accrual,
            (frozen_rating_output_ledger_c_calculations_state_tax) as state_tax_accrual,
            (
                frozen_rating_output_ledger_c_calculations_state_tax_1
            ) as state_tax_1_accrual,
            (
                frozen_rating_output_ledger_c_calculations_state_tax_2
            ) as state_tax_2_accrual,
            (
                frozen_rating_output_ledger_c_calculations_state_tax_3
            ) as state_tax_3_accrual,
            (
                frozen_rating_output_ledger_c_calculations_premium_tax_deduction
            ) as premium_tax_deduction_accrual,
            (
                frozen_rating_output_ledger_c_calculations_fire_marshal_tax_deduction
            ) as fire_marshal_tax_deduction_accrual,
            (frozen_rating_output_ledger_c_calculations_mga_fee) as mga_fee_accrual,
            (
                frozen_rating_output_ledger_c_calculations_figa_recoupment
            ) as figa_recoupment_accrual,
            -- -- Written Premium
            frozen_rating_output_premium_amount
            - frozen_rating_output_ledger_c_rates_total_amount
            as total_written_premium_amount,
            frozen_rating_output_ledger_a_rates_hurricane_amount
            + frozen_rating_output_ledger_b_rates_hurricane_amount
            as hurricane_written_premium_amount,
            frozen_rating_output_ledger_a_rates_fire_amount
            + frozen_rating_output_ledger_b_rates_fire_amount
            as fire_written_premium_amount,
            frozen_rating_output_ledger_flood_rates_total_amount
            as flood_written_premium_amount,
            (
                frozen_rating_output_ledger_a_rates_earthquake_amount
                + frozen_rating_output_ledger_a_rates_earthquake_1_amount
                + frozen_rating_output_ledger_a_rates_earthquake_2_amount
                + frozen_rating_output_ledger_a_rates_earthquake_3_amount
                + frozen_rating_output_ledger_b_rates_earthquake_amount
                + frozen_rating_output_ledger_b_rates_earthquake_1_amount
                + frozen_rating_output_ledger_b_rates_earthquake_2_amount
                + frozen_rating_output_ledger_b_rates_earthquake_3_amount
            ) as earthquake_written_premium_amount,
            (
                frozen_rating_output_ledger_a_rates_wild_fire_amount
                + frozen_rating_output_ledger_a_rates_wild_fire_1_amount
                + frozen_rating_output_ledger_a_rates_wild_fire_2_amount
                + frozen_rating_output_ledger_a_rates_wild_fire_3_amount
                + frozen_rating_output_ledger_b_rates_wild_fire_amount
                + frozen_rating_output_ledger_b_rates_wild_fire_1_amount
                + frozen_rating_output_ledger_b_rates_wild_fire_2_amount
                + frozen_rating_output_ledger_b_rates_wild_fire_3_amount
            ) as wild_fire_written_premium_amount,
            frozen_rating_output_ledger_a_rates_winter_storm_amount
            + frozen_rating_output_ledger_b_rates_winter_storm_amount
            as winter_storm_written_premium_amount,
            frozen_rating_output_ledger_a_rates_severe_convective_storm_amount
            + frozen_rating_output_ledger_b_rates_severe_convective_storm_amount
            as severe_convective_storm_written_premium_amount,
            frozen_rating_output_ledger_a_rates_all_other_perils_amount
            + frozen_rating_output_ledger_b_rates_all_other_perils_amount
            as all_other_perils_written_premium_amount,
            frozen_rating_output_ledger_c_rates_total_amount
            as additional_surplus_and_fees_written_premium_amount,
            frozen_rating_output_ledger_c_calculations_surplus_amount
            as surplus_written_premium_amount,
            frozen_rating_output_ledger_c_calculations_surcharge_amount
            as surcharge_written_premium_amount,
            frozen_rating_output_ledger_c_calculations_state_tax_amount
            as state_tax_written_premium_amount,
            frozen_rating_output_ledger_c_calculations_state_tax_1_amount
            as state_tax_1_written_premium_amount,
            frozen_rating_output_ledger_c_calculations_state_tax_2_amount
            as state_tax_2_written_premium_amount,
            frozen_rating_output_ledger_c_calculations_state_tax_3_amount
            as state_tax_3_written_premium_amount,
            frozen_rating_output_ledger_c_calculations_premium_tax_deduction_amount
            as premium_tax_deduction_written_premium_amount,
            frozen_rating_output_ledger_c_calculations_fire_marshal_tax_deduction_amount
            as fire_marshal_tax_deduction_written_premium_amount,
            frozen_rating_output_ledger_c_calculations_mga_fee_amount
            as mga_fee_written_premium_amount,
            frozen_rating_output_ledger_c_calculations_installment_fee_amount
            as installment_fee_written_premium_amount,
            frozen_rating_output_ledger_c_calculations_inspection_fee_amount
            as inspection_fee_written_premium_amount,
            (
                frozen_rating_output_ledger_c_calculations_empt_fee_amount
            ) as empt_fee_written_premium_amount,
            frozen_rating_output_ledger_c_calculations_figa_recoupment_amount
            as figa_recoupment_written_premium_amount,
            -- earned premium
            earned_exposures * premium * amt_multiplier as total_earned_premium_amount,
            hurricane_premium_accrual
            * earned_exposures
            * amt_multiplier as hurricane_earned_premium_amount,
            fire_premium_accrual
            * earned_exposures
            * amt_multiplier as fire_earned_premium_amount,
            flood_premium_accrual
            * earned_exposures
            * amt_multiplier as flood_earned_premium_amount,
            earthquake_premium_accrual
            * earned_exposures
            * amt_multiplier as earthquake_earned_premium_amount,
            wild_fire_premium_accrual
            * earned_exposures
            * amt_multiplier as wild_fire_earned_premium_amount,
            winter_storm_premium_accrual
            * earned_exposures
            * amt_multiplier as winter_storm_earned_premium_amount,
            severe_convective_storm_premium_accrual
            * earned_exposures
            * amt_multiplier as severe_convective_storm_earned_premium_amount,
            all_other_perils_premium_accrual
            * earned_exposures
            * amt_multiplier as all_other_perils_earned_premium_amount,
            additional_surplus_and_fees_accrual
            * earned_exposures
            * amt_multiplier as additional_surplus_and_fees_earned_premium_amount,
            surplus_accrual
            * earned_exposures
            * amt_multiplier as surplus_earned_premium_amount,
            surcharge_accrual
            * earned_exposures
            * amt_multiplier as surcharge_earned_premium_amount,
            state_tax_accrual
            * earned_exposures
            * amt_multiplier as state_tax_earned_premium_amount,
            state_tax_1_accrual
            * earned_exposures
            * amt_multiplier as state_tax_1_earned_premium_amount,
            state_tax_2_accrual
            * earned_exposures
            * amt_multiplier as state_tax_2_earned_premium_amount,
            state_tax_3_accrual
            * earned_exposures
            * amt_multiplier as state_tax_3_earned_premium_amount,
            premium_tax_deduction_accrual
            * earned_exposures
            * amt_multiplier as premium_tax_deduction_earned_premium_amount,
            fire_marshal_tax_deduction_accrual
            * earned_exposures
            * amt_multiplier as fire_marshal_tax_deduction_earned_premium_amount,
            mga_fee_accrual
            * earned_exposures
            * amt_multiplier as mga_fee_earned_premium_amount,
            figa_recoupment_accrual
            * earned_exposures
            * amt_multiplier as figa_recoupment_earned_premium_amount
        from mx_rec f  -- where
    -- snapshot_start_date < current_date()
    )
select
    bright_policy_id,
    full_policy_number,
    policy_term,
    policy_effective_date,
    policy_expiration_date,
    policy_final_term_date,
    -- policy_status,
    state,
    product_line,
    insurance_carrier_name,
    sum(total_earned_premium_amount) as total_earned_premium_amount,
    sum(hurricane_earned_premium_amount) as hurricane_earned_premium_amount,
    sum(fire_earned_premium_amount) as fire_earned_premium_amount,
    sum(flood_earned_premium_amount) as flood_earned_premium_amount,
    sum(earthquake_earned_premium_amount) as earthquake_earned_premium_amount,
    sum(wild_fire_earned_premium_amount) as wild_fire_earned_premium_amount,
    sum(winter_storm_earned_premium_amount) as winter_storm_earned_premium_amount,
    sum(
        severe_convective_storm_earned_premium_amount
    ) as severe_convective_storm_earned_premium_amount,
    sum(
        all_other_perils_earned_premium_amount
    ) as all_other_perils_earned_premium_amount,
    sum(
        additional_surplus_and_fees_earned_premium_amount
    ) as additional_surplus_and_fees_earned_premium_amount,
    sum(surplus_earned_premium_amount) as surplus_earned_premium_amount,
    sum(surcharge_earned_premium_amount) as surcharge_earned_premium_amount,
    sum(state_tax_earned_premium_amount) as state_tax_earned_premium_amount,
    sum(state_tax_1_earned_premium_amount) as state_tax_1_earned_premium_amount,
    sum(state_tax_2_earned_premium_amount) as state_tax_2_earned_premium_amount,
    sum(state_tax_3_earned_premium_amount) as state_tax_3_earned_premium_amount,
    sum(
        premium_tax_deduction_earned_premium_amount
    ) as premium_tax_deduction_earned_premium_amount,
    sum(
        fire_marshal_tax_deduction_earned_premium_amount
    ) as fire_marshal_tax_deduction_earned_premium_amount,
    sum(mga_fee_earned_premium_amount) as mga_fee_earned_premium_amount,
    sum(figa_recoupment_earned_premium_amount) as figa_recoupment_earned_premium_amount,
    sum(total_written_premium_amount) as total_written_premium_amount,
    sum(hurricane_written_premium_amount) as hurricane_written_premium_amount,
    sum(fire_written_premium_amount) as fire_written_premium_amount,
    sum(flood_written_premium_amount) as flood_written_premium_amount,
    sum(earthquake_written_premium_amount) as earthquake_written_premium_amount,
    sum(wild_fire_written_premium_amount) as wild_fire_written_premium_amount,
    sum(winter_storm_written_premium_amount) as winter_storm_written_premium_amount,
    sum(
        severe_convective_storm_written_premium_amount
    ) as severe_convective_storm_written_premium_amount,
    sum(
        all_other_perils_written_premium_amount
    ) as all_other_perils_written_premium_amount,
    sum(
        additional_surplus_and_fees_written_premium_amount
    ) as additional_surplus_and_fees_written_premium_amount,
    sum(surplus_written_premium_amount) as surplus_written_premium_amount,
    sum(surcharge_written_premium_amount) as surcharge_written_premium_amount,
    sum(
        installment_fee_written_premium_amount
    ) as installment_fee_written_premium_amount,
    sum(inspection_fee_written_premium_amount) as inspection_fee_written_premium_amount,
    sum(empt_fee_written_premium_amount) as empt_fee_written_premium_amount,
    sum(state_tax_written_premium_amount) as state_tax_written_premium_amount,
    sum(state_tax_1_written_premium_amount) as state_tax_1_written_premium_amount,
    sum(state_tax_2_written_premium_amount) as state_tax_2_written_premium_amount,
    sum(state_tax_3_written_premium_amount) as state_tax_3_written_premium_amount,
    sum(
        premium_tax_deduction_written_premium_amount
    ) as premium_tax_deduction_written_premium_amount,
    sum(
        fire_marshal_tax_deduction_written_premium_amount
    ) as fire_marshal_tax_deduction_written_premium_amount,
    sum(mga_fee_written_premium_amount) as mga_fee_written_premium_amount,
    sum(
        figa_recoupment_written_premium_amount
    ) as figa_recoupment_written_premium_amount
from details
group by
    bright_policy_id,
    full_policy_number,
    policy_term,
    policy_effective_date,
    policy_expiration_date,
    policy_final_term_date,
    policy_status,
    state,
    product_line,
    insurance_carrier_name
order by bright_policy_id, full_policy_number, policy_term
